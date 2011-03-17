require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  setup do
    @receipt = receipts(:one)
    @img = fixture_file_upload('files/receipt0.gif', 'image/gif')
    @receipt.attributes = @receipt.attributes.merge({:img => @img})
    @receipt.mq_extract_store_name = stub(:send => true)
    @user = users(:one)
    @receipt.user = @user
    sign_in User.first
  end

  test "handle message from store name extractor" do
    store_name = "store #{rand}"
    message = "{\"receipt\":{\"id\":2,\"extracted_store_name\":\"#{store_name}\"}}"
    ReceiptsController.handle_message_from_store_name_extractor message
    assert_equal store_name, Receipt.find(2).extracted_store_name
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:receipts)
  end

  test "should create receipt" do
    assert_difference('Receipt.count') do
      post :create, :receipt => @receipt.attributes, :user_id => @user.id
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show receipt" do
    get :show, :id => @receipt.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @receipt.to_param
    assert_response :success
  end

  test "should update receipt" do
    put :update, :id => @receipt.to_param, :receipt => @receipt.attributes
    assert_redirected_to receipt_path(assigns(:receipt), :notice => "Receipt was successfully updated.")
  end

  test "should destroy receipt" do
    assert_difference('Receipt.count', -1) do
      delete :destroy, :id => @receipt.to_param
    end
    assert_redirected_to receipts_path
  end
end
