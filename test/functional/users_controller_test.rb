require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => { :name => "Pepe", :email => "pepe@example.com" }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => users(:jaime).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => users(:jaime).to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => users(:jaime).to_param, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:jaime).to_param
    end

    assert_redirected_to users_path
  end
end
