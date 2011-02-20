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
end
