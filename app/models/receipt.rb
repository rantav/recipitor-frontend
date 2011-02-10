class Receipt < ActiveRecord::Base
  has_attached_file :img, 
    :styles => { :medium => "300x300>", :thumb => "100x100#" },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => ":attachment/:id/:style/:basename.:extension"

  validates_attachment_presence :img
end
