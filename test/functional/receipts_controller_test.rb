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

  test "handle message from store name extractor - one store name" do
    store_name = "store #{rand}"
    message = <<MESSAGE
    {
      "receipt": {
        "id": "2",
        "extracted_store_names": [{
          "name": "#{store_name}",
          "distance": 0.2857142857142857 
        }],
        "extracted_tokens_list": [] 
      }
    }
MESSAGE
    ReceiptsController.handle_message_from_store_name_extractor message
    assert_equal store_name, Receipt.find(2).extracted_store_name
  end

  test "handle message from store name extractor - receipt already has a store name" do
    message = <<MESSAGE
    {
      "receipt": {
        "id": "3",
        "extracted_store_names": [{
          "name": "foo",
          "distance": 0.2857142857142857 
        }],
        "extracted_tokens_list": [] 
      }
    }
MESSAGE
    ReceiptsController.handle_message_from_store_name_extractor message
    assert_equal "bla", Receipt.find(3).extracted_store_name
  end

  test "handle message from store name extractor - two store names" do
    store_name1 = "store #{rand}"
    store_name2 = "store #{rand}"
    message = <<MESSAGE
    {
      "receipt": {
        "id": "2",
        "extracted_store_names": [
        {
          "name": "#{store_name1}",
          "distance": 0.2857142857142857 
        },
        {
          "name": "#{store_name2}",
          "distance": 0.2857142857142857 
        }],
        "extracted_tokens_list": [] 
      }
    }
MESSAGE
    ReceiptsController.handle_message_from_store_name_extractor message
    assert_equal store_name1 + " or " + store_name2, Receipt.find(2).extracted_store_name
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
