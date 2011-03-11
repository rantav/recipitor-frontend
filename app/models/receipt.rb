class Receipt < ActiveRecord::Base

  require 'iconv'

  belongs_to :user
  
  has_attached_file :img, 
    :styles => {:thumb => "100x100"},
    :storage => PAPERCLIP_STORAGE_MECHANISM,
    :s3_credentials => Rails.root.join('config/s3.yml'),
    :s3_permissions => 'authenticated-read',
    :s3_protocol => 'https',
    :path => PAPERCLIP_PATH,
    :url => PAPERCLIP_URL
    #:default_url => '/images/missing_:style.png'

  before_post_process :friendly_file_name
  validates_attachment_presence :img
  validates_attachment_content_type :img, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/bmp', 'image/png' ]
  validates_attachment_size :img, :less_than => 2.megabytes

  # The following authorization related methods were insipred by the good writeup at http://thewebfellas.com/blog/2009/8/29/protecting-your-paperclip-downloads
  def authorized?(user)
    user.admin? or self.user == user
  end

  def img_url(style = nil, include_updated_timestamp = true)
    begin
      url = Paperclip::Interpolations.interpolate('/rcpt/:id/:style/:filename', img, style || img.default_style)
    rescue TypeError => e
      logger.error("ERROR: TypeError: #{e}")
      # TODO(ran): fix this
      return "TODO - NOT FOUND"
    end
    include_updated_timestamp && img.updated_at ? [url, img.updated_at].compact.join(url.include?("?") ? "&" : "?") : url
  end

  def authenticated_url(style = nil, expires_in = 10.seconds)
    if (img.respond_to?("bucket_name"))
      AWS::S3::S3Object.url_for(img.path(style || img.default_style), img.bucket_name, :expires_in => expires_in, :use_ssl => img.s3_protocol == 'https')
    else
      img.to_s
    end
  end

  private
  def friendly_file_name
    extension = File.extname(img_file_name).gsub(/^\.+/, '')
    filename = img_file_name.gsub(/\.#{extension}$/, '')
      self.img.instance_write(:file_name, "#{friendly_url(filename)}.#{extension}")
  end
  
  def friendly_url(str)
    # Based on permalink_fu by Rick Olsen

    # Escape str by transliterating to UTF-8 with Iconv
    s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s

    # Downcase string
    s.downcase!

    # Remove apostrophes so isn't changes to isnt
    s.gsub!(/'/, '')

    # Replace any non-letter or non-number character with a space
    s.gsub!(/[^A-Za-z0-9]+/, ' ')

    # Remove spaces from beginning and end of string
    s.strip!

    # Replace groups of spaces with single hyphen
    s.gsub!(/\ +/, '-')

    return s
  end
end
