class Receipt < ActiveRecord::Base

  require 'iconv'

  belongs_to :user
  
  @@default_image = "/images/missing_original.png"
  
  has_attached_file :img, 
    :styles => {:thumb => "100x100"},
    :storage => PAPERCLIP_STORAGE_MECHANISM,
    :s3_credentials => Rails.root.join('config/s3.yml'),
    :s3_permissions => 'authenticated-read',
    :s3_protocol => 'https',
    :path => PAPERCLIP_PATH,
    :url => PAPERCLIP_URL,
    :default_url => '/images/missing_:style.png'

  
  before_post_process :friendly_file_name
  validates_attachment_presence :img
  validates_attachment_content_type :img, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/bmp', 'image/png' ]
  validates_attachment_size :img, :less_than => 2.megabytes

  after_save :extract_store_name

  # The following authorization related methods were insipred by the good writeup at http://thewebfellas.com/blog/2009/8/29/protecting-your-paperclip-downloads
  def authorized?(user)
    user.admin? or self.user == user
  end

  def img_url(style = nil, include_updated_timestamp = true)
    begin
      url = Paperclip::Interpolations.interpolate('/rcpt/:id/:style/:filename', img, style || img.default_style)
    rescue TypeError => e
      logger.error("ERROR: TypeError: #{e}")
      return @@default_image
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

  # Sends a request to extract a store name.
  # A request is sent to a message queue to be processed at a later time by the store name service extractor.
  # The message would look something linke this:
  # {"receipt":{"created_at":"2011-03-15T10:36:35Z","description":null,"id":127,"img_content_type":"image/gif","img_file_name":"v-model.gif","img_file_size":33875,"img_updated_at":"2011-03-15T10:36:35Z","updated_at":"2011-03-15T10:36:35Z","user_id":1},"url":"https://s3.amazonaws.com/recipitor_receipts_prod/imgs/127/original/v-model.gif?AWSAccessKeyId=AKIAJ77AXDKGDKTJEOMQ&Expires=1300271797&Signature=gahFpALNAc%2Bs3%2Bj5MAdSSBI6nLQ%3D"}
  # The s3 URL is set to expire in 24h.
  def extract_store_name
    return unless created_at == updated_at # this is a new receipt, first time saved
    q = MessageQueue.new(Q_EXTRACT_STORE_NAME_REQUEST)
    q.send(build_message_for_ocr)
  end

  # Builds a json message containing among other things the url of the image that can be used for OCR.
  # The message is returned as a plain string
  def build_message_for_ocr
    json = as_json
    # add the url with a TTL of 24h
    url = authenticated_url(:original, (3600 * 24))
    json["url"] = url
    json.to_json
  end

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
