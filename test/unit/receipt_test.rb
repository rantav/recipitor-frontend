require 'test_helper'

class ReceiptTest < ActiveSupport::TestCase
  
  test "should not save receipt without attachment" do
    receipt = Receipt.new
    assert !receipt.save
  end
  
  test "should save receipt with attachment" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt0.gif', 'image/gif'))
    assert receipt.save
  end

  test "attachment content type image/gif should be ok" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt0.gif', 'image/gif'))
    assert receipt.save
  end
  
  test "attachment content type image/jpg should be ok" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt1.jpg', 'image/jpg'))
    assert receipt.save
  end
  
  test "attachment content type image/jpeg should be ok" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt3.jpeg', 'image/jpeg'))
    assert receipt.save
  end

  test "attachment content type image/bmp should be ok" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt4.bmp', 'image/bmp'))
    assert receipt.save
  end
  
  test "attachment content type image/pmg should be ok" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt5.png', 'image/png'))
    assert receipt.save
  end

  test "attachment content type text/plain should fail" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt6.txt', 'text/plain'))
    assert !receipt.save
  end
  
  ## This test runs for too long... (57 seconds...)
#  test "attachment too big should be rejected" do
#    receipt = Receipt.create(:img => fixture_file_upload('files/large_img.jpg', 'image/jpg'))
#    assert !receipt.save
#  end

  test "authorization fails for new user" do
    receipt = Receipt.new
    user = User.new
    assert(!receipt.authorized?(user))
  end
  
  test "authorization passes for admins" do
    receipt = Receipt.new
    user = User.new
    user.admin = true
    assert(receipt.authorized?(user))
  end
  
  test "authorization passes for owner of the receipt but not admin" do
    receipt = Receipt.new
    user = User.new
    receipt.user = user
    assert(receipt.authorized?(user))
  end

  test "building default img_url" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt0.gif', 'image/gif'))
    assert_match /\/rcpt\/\d+\/original\/receipt0.gif\?\d+/, receipt.img_url
  end

  test "building not-found img_url (still TODO)" do
    receipt = Receipt.new
    assert_equal "TODO - NOT FOUND", receipt.img_url
  end

  test "building img authenticated_url on localhost (not reall authenticated, but used for local dev)" do
    receipt = Receipt.create(:img => fixture_file_upload('files/receipt0.gif', 'image/gif'))
    assert_match /\/system\/imgs\/\d+\/original\/receipt0.gif\?\d+/, receipt.authenticated_url
  end

  test "building img authenticated_url on s3" do
    #TODO(ran): Think about how to test this...
  end
  
end
