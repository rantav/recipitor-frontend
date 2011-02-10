class Receipt < ActiveRecord::Base
  has_attached_file :img, 
    :styles => { :thumb => "100x100#" },
    :storage => PAPERCLIP_STORAGE_MECHANISM,
    :s3_credentials => Rails.root.join('config/s3.yml'),
    :path => PAPERCLIP_PATH

  validates_attachment_presence :img
end
