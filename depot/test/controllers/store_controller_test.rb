require 'test_helper'

class StoreControllerTest < ActionController::TestCase

  test "should update session counter" do
    assert_nil session[:counter]
    get :index
    assert_equal session[:counter],1
    get :index
    assert_equal session[:counter],2
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
