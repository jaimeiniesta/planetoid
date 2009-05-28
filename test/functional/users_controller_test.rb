require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  ################
  # Public actions
  ################
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    
    assigns(:users).each do |user|
      assert_no_tag :a, :content => "Edit", :attributes => {:href => edit_user_path(user)}
      assert_no_tag :a, :content => "Destroy", :attributes => {:href => user_path(user)}
    end
    
    assert_no_tag :a, :content => "New user", :attributes => {:href => new_user_path}
  end

  def test_should_show_user
    get :show, :id => users(:jaime).to_param
    assert_response :success
    assert assigns(:user)
    assert_no_tag :a, :content => "Edit", :attributes => {:href => edit_user_path(assigns(:user))}
  end
  
  ############################################
  # Public actions as admin shows admin links
  ############################################
  
  def test_should_get_index_as_admin
    login_as_admin
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    
    assigns(:users).each do |user|
      assert_tag :a, :content => "Edit", :attributes => {:href => edit_user_path(user)}
      assert_tag :a, :content => "Destroy", :attributes => {:href => user_path(user)}
    end
    
    assert_tag :a, :content => "New user", :attributes => {:href => new_user_path}
  end

  def test_should_show_user_as_admin
    login_as_admin
    get :show, :id => users(:jaime).to_param
    assert_response :success
    
    assert assigns(:user)
    assert_tag :a, :content => "Edit", :attributes => {:href => edit_user_path(assigns(:user))}
  end

  ################
  # Admin actions
  ################

  def test_should_get_new
    login_as_admin
    get :new
    assert_response :success
  end

  def test_should_create_user
    login_as_admin
    assert_difference('User.count') do
      post :create, :user => { :name => "Pepe", :email => "pepe@example.com" }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_get_edit
    login_as_admin
    get :edit, :id => users(:jaime).to_param
    assert_response :success
  end

  def test_should_update_user
    login_as_admin
    put :update, :id => users(:jaime).to_param, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end

  def test_should_destroy_user
    login_as_admin
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:jaime).to_param
    end

    assert_redirected_to users_path
  end
  
  #########################################
  # Redirect if not admin
  #########################################

  def test_should_not_get_new_if_not_admin
    get :new
 
    assert_redirected_to login_path
  end

  def test_should_not_create_user_if_not_admin
    assert_no_difference('User.count') do
      post :create, :user => { :name => "Pepe", :email => "pepe@example.com" }
    end

    assert_redirected_to login_path
  end

  def test_should_not_get_edit_if_not_admin
    get :edit, :id => users(:jaime).to_param

    assert_redirected_to login_path
  end

  def test_should_not_update_user_if_not_admin
    put :update, :id => users(:jaime).to_param, :user => { }
    
    assert_redirected_to login_path
  end

  def test_should_not_destroy_user_if_not_admin
    assert_no_difference('User.count') do
      delete :destroy, :id => users(:jaime).to_param
    end

    assert_redirected_to login_path
  end
  
end
