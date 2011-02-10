class Receipt < ActiveRecord::Base
  has_attached_file :img, 
    :styles => {:thumb => "100x100#"},
    :storage => PAPERCLIP_STORAGE_MECHANISM,
    :s3_credentials => Rails.root.join('config/s3.yml'),
    :s3_permissions => 'private',
    :path => PAPERCLIP_PATH

  validates_attachment_presence :img
  validates_attachment_content_type :img, :content_type => ['image/jpg', 'image/jpeg', 'image/gif', 'image/bmp', 'image/png' ]
  validates_attachment_size :img, :less_than => 2.megabytes

end
