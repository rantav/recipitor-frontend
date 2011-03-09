require 'test_helper'

class Admin::ReceiptsControllerTest < ActionController::TestCase
  setup do
    @receipt = receipts(:one)
    img = fixture_file_upload('files/receipt0.gif', 'image/gif')
    @receipt.attributes = @receipt.attributes.merge({:img => img})
    @user = users(:one)
    @receipt.user = @user
    sign_in User.first
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
    assert_redirected_to admin_receipt_path(assigns(:receipt), :notice => "Receipt was successfully updated.")
  end

  test "should destroy receipt" do
    assert_difference('Receipt.count', -1) do
      delete :destroy, :id => @receipt.to_param
    end

    assert_redirected_to admin_receipts_path
  end
end
