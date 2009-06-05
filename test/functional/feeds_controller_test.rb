require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  
  ################
  # Public actions
  ################
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
    
    assigns(:feeds).each do |feed|
      assert_no_tag :a, :content => "Edit", :attributes => {:href => edit_feed_path(feed)}
      assert_no_tag :a, :content => "Destroy", :attributes => {:href => feed_path(feed)}
    end
    
    assert_no_tag :a, :content => "New feed", :attributes => {:href => new_feed_path}    
  end
  
  ############################################
  # Public actions as admin shows admin links
  ############################################  
  
  def test_should_get_index_as_admin
    login_as_admin
    get :index
    assert_response :success
    assert_not_nil assigns(:feeds)
    
    assigns(:feeds).each do |feed|
      assert_tag :a, :content => "Edit", :attributes => {:href => edit_feed_path(feed)}
      assert_tag :a, :content => "Destroy", :attributes => {:href => feed_path(feed)}
    end
    
    assert_tag :a, :content => "New feed", :attributes => {:href => new_feed_path}    
  end
  
  ################
  # Admin actions
  ################

  def test_should_get_new
    login_as_admin
    get :new
    assert_response :success
  end

  def test_should_create_feed
    login_as_admin
    assert_difference('Feed.count') do
      post :create, :feed => { :user_id => users(:jaime).id, :feed_url => "http://feeds.feedburner.com/PageRankAlert" }
    end

    assert_redirected_to feeds_path
  end

  def test_should_get_edit
    login_as_admin
    get :edit, :id => feeds(:jaime_blog).to_param
    assert_response :success
  end

  def test_should_update_feed
    login_as_admin
    put :update, :id => feeds(:jaime_blog).to_param, :feed => { }
    assert_redirected_to feeds_path
  end

  def test_should_destroy_feed
    login_as_admin
    assert_difference('Feed.count', -1) do
      delete :destroy, :id => feeds(:jaime_blog).to_param
    end

    assert_redirected_to feeds_path
  end
  
  ########################
  # Redirect if not admin
  ########################

  def test_should_not_get_new_if_not_admin
    get :new
  
    assert_redirected_to login_path
  end

  def test_should_not_create_feed_if_not_admin
    assert_no_difference('Feed.count') do
      post :create, :feed => { :user_id => users(:jaime).id, :feed_url => "http://feeds.feedburner.com/PageRankAlert" }
    end

    assert_redirected_to login_path
  end

  def test_should_not_get_edit_if_not_admin
    get :edit, :id => feeds(:jaime_blog).to_param

    assert_redirected_to login_path
  end

  def test_should_not_update_feed_if_not_admin
    put :update, :id => feeds(:jaime_blog).to_param, :feed => { }

    assert_redirected_to login_path
  end

  def test_should_not_destroy_feed_if_not_admin
    assert_no_difference('Feed.count') do
      delete :destroy, :id => feeds(:jaime_blog).to_param
    end

    assert_redirected_to login_path
  end
end
