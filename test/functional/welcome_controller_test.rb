require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    
    assert assigns(:users)
    assert assigns(:entries)
    
    assert_response :success
  end
end
