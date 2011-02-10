class Receipt < ActiveRecord::Base
  has_attached_file :img, 
    :styles => { :thumb => "100x100#" },
    :storage => PAPERCLIP_STORAGE_MECHANISM,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml"
    #:path => ":attachment/:id/:style/:basename.:extension"

  validates_attachment_presence :img
end
