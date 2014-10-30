require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  setup do
    # Make sure that we are logged in
    user = FactoryGirl.create(:user)
    UserSession.create(login: user.username, password: user.password)
    @account = FactoryGirl.create(:account)
  end

  test "should get index" do
    get :index
    assert_response 200
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
   assert_difference('Account.count') do
      post :create, :account => FactoryGirl.attributes_for(:account)
    end
    assert_redirected_to account_path(assigns(:account))
  end

  test "should show account" do
    get :show, :id => @account.to_param
    assert_response 200
  end

  test "should get edit" do
    get :edit, :id => @account.to_param
    assert_response :success
  end

  test "should update account" do
    put :update, :id => @account.to_param, :account => @account.attributes
    assert_redirected_to account_path(assigns(:account))
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete :destroy, :id => @account.to_param
    end

    assert_redirected_to accounts_path
  end
end
