require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  
  #################
  # Public actions
  #################
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
    
    assigns(:entries).each do |entry|
      assert_no_tag :a, :content => "Destroy", :attributes => {:href => entry_path(entry)}
    end
  end

  def test_should_show_entry
    get :show, :id => entries(:jaime_blog_1).to_param
    assert_response :success
    
    assert assigns(:entry)
  end
  
  ############################################
  # Public actions as admin shows admin links
  ############################################  

  def test_should_get_index_as_admin
    login_as_admin
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
    
    assigns(:entries).each do |entry|
      assert_tag :a, :content => "Destroy", :attributes => {:href => entry_path(entry)}
    end
  end

  #################
  # Admin actions
  #################

  def test_should_destroy_entry
    login_as_admin
    assert_difference('Entry.count', -1) do
      delete :destroy, :id => entries(:jaime_blog_1).to_param
    end

    assert_redirected_to entries_path
  end
  
  ########################
  # Redirect if not admin
  ########################

  def test_should_not_destroy_entry_if_not_admin
    assert_no_difference('Entry.count') do
      delete :destroy, :id => entries(:jaime_blog_1).to_param
    end

    assert_redirected_to login_path
  end
end
