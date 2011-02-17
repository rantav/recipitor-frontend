class User < ActiveRecord::Base
  has_many :receipts
end
