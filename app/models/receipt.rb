class Receipt < ActiveRecord::Base
  
  belongs_to :user
  
  has_attached_file :img, 
    :styles => {:thumb => "100x100#"},
    :storage => PAPERCLIP_STORAGE_MECHANISM,
    :s3_credentials => Rails.root.join('config/s3.yml'),
    :s3_permissions => 'authenticated-read',
    :s3_protocol => 'https',
    :path => PAPERCLIP_PATH,
    :url => PAPERCLIP_URL

  validates_attachment_presence :img
  validates_attachment_content_type :img, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/bmp', 'image/png' ]
  validates_attachment_size :img, :less_than => 2.megabytes

  # The following authorization related methods were insipred by the good writeup at http://thewebfellas.com/blog/2009/8/29/protecting-your-paperclip-downloads
  def authorized?(user)
    #TODO(ran): Implement this by user
    user != :guest
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

end
