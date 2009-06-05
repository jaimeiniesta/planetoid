require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  
  #################
  # Public actions
  #################
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

end
