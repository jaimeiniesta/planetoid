require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  test "should show entry" do
    get :show, :id => entries(:jaime_blog_1).to_param
    assert_response :success
  end

  test "should destroy entry" do
    assert_difference('Entry.count', -1) do
      delete :destroy, :id => entries(:jaime_blog_1).to_param
    end

    assert_redirected_to entries_path
  end
end
