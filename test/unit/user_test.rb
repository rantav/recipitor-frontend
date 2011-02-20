require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "new user has no receipts" do
    user = User.new
    assert_empty user.receipts
  end
  
  test "new user can add a receipt" do
    user = User.create
    user.receipts.create
    assert_not_empty user.receipts
  end
end
