class Receipt < ActiveRecord::Base
  has_attached_file :img, :styles => { :medium => "300x300>", :thumb => "100x100#" }
  validates_attachment_presence :img
end
