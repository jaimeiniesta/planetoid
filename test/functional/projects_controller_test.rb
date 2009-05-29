require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  
  ################
  # Public actions
  ################  
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
    
    assigns(:projects).each do |project|
      assert_no_tag :a, :content => "Edit", :attributes => {:href => edit_project_path(project)}
      assert_no_tag :a, :content => "Destroy", :attributes => {:href => project_path(project)}
    end
    
    assert_no_tag :a, :content => "New project", :attributes => {:href => new_project_path}    
  end
  
  def test_should_show_project
    get :show, :id => projects(:planetoid).to_param
    assert_response :success
    
    assert assigns(:project)
    assert_no_tag :a, :content => "Edit", :attributes => {:href => edit_project_path(assigns(:project))}    
  end
  
  ############################################
  # Public actions as admin shows admin links
  ############################################    

  def test_should_get_index_as_admin
    login_as_admin
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
    
    assigns(:projects).each do |project|
      assert_tag :a, :content => "Edit", :attributes => {:href => edit_project_path(project)}
      assert_tag :a, :content => "Destroy", :attributes => {:href => project_path(project)}
    end
    
    assert_tag :a, :content => "New project", :attributes => {:href => new_project_path}    
  end
  
  def test_should_show_project_as_admin
    login_as_admin
    get :show, :id => projects(:planetoid).to_param
    assert_response :success
    
    assert assigns(:project)
    assert_tag :a, :content => "Edit", :attributes => {:href => edit_project_path(assigns(:project))}    
  end
  
  ################
  # Admin actions
  ################  

  def test_should_get_new
    login_as_admin
    get :new
    assert_response :success
  end

  def test_should_create_project
    login_as_admin
    assert_difference('Project.count') do
      post :create, :project => { :name => 'A brand new project', :url => 'http://www.brandnewproject.com' }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_get_edit
    login_as_admin
    get :edit, :id => projects(:planetoid).to_param
    assert_response :success
  end

  def test_should_update_project
    login_as_admin
    put :update, :id => projects(:planetoid).to_param, :project => { }
    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_destroy_project
    login_as_admin
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:planetoid).to_param
    end

    assert_redirected_to projects_path
  end
  
  ########################
  # Redirect if not admin
  ########################
  def test_should_not_get_new_if_not_admin
    get :new
    assert_redirected_to login_path
  end

  def test_should_not_create_project_if_not_admin
    assert_no_difference('Project.count') do
      post :create, :project => { :name => 'A brand new project' }
    end

    assert_redirected_to login_path
  end

  def test_should_get_not_edit_if_not_admin
    get :edit, :id => projects(:planetoid).to_param
    assert_redirected_to login_path
  end

  def test_should_not_update_project_if_not_admin
    put :update, :id => projects(:planetoid).to_param, :project => { }
    assert_redirected_to login_path
  end

  def test_should_not_destroy_project_if_not_admin
    assert_no_difference('Project.count', -1) do
      delete :destroy, :id => projects(:planetoid).to_param
    end

    assert_redirected_to login_path
  end  
    
end
