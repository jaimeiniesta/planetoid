require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_redirect_if_already_logged_in
    login_as_admin
    get :new
    assert_redirected_to '/'
  end
  
  def test_should_login_and_redirect_to_home
    assert_nil session[:admin]
    post :create, :login => PLANETOID_CONF[:admin][:login].to_s, :password => PLANETOID_CONF[:admin][:password].to_s
    assert_equal session[:admin], true
    assert_response :redirect
    assert_redirected_to '/'
    assert_not_nil flash[:notice]
  end

  def test_should_login_and_redirect_to_home_with_a_crypted_password
    assert_nil session[:admin]
    PLANETOID_CONF[:admin][:hash_password] = true
    PLANETOID_CONF[:admin][:password] = Digest::SHA1.hexdigest('wadus')
    
    post :create, :login => PLANETOID_CONF[:admin][:login].to_s, :password => PLANETOID_CONF[:admin][:password].to_s
    assert_equal session[:admin], true
    assert_response :redirect
    assert_redirected_to '/'
    assert_not_nil flash[:notice]
  end
  
  def test_should_fail_login_and_redirect_to_login
    assert_nil session[:admin]
    post :create, :login => 'fake', :password => 'badpassword'
    assert_nil session[:admin]
    assert_response :redirect
    assert_redirected_to '/login'
    assert_not_nil flash[:error]
  end
  
  def test_should_fail_and_redirect_to_home_with_a_crypted_password
    assert_nil session[:admin]
    PLANETOID_CONF[:admin][:hash_password] = true
    
    post :create, :login => PLANETOID_CONF[:admin][:login].to_s, :password => PLANETOID_CONF[:admin][:password].to_s
    assert_equal session[:admin], true
    assert_response :redirect
    assert_redirected_to '/'
    assert_not_nil flash[:notice]
  end

  def test_should_logout_and_redirect_to_home
    session[:admin] = true
    get :destroy
    assert_nil session[:admin]
    assert_response :redirect
    assert_redirected_to '/'
  end
end
