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

  test "markup needed for store.js.coffee is in place" do
    get :index
    assert_select '.store .entry > img', 3
    assert_select '.entry input[type=submit]', 3
  end
end
