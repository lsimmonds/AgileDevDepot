require 'test_helper'
class ProductsControllerTest < ActionController::TestCase
  test "should properly display index" do
    get :index
    assert_response :success
    assert_select '#columns #side a', minimum: 4
    assert_select 'dt', 'Programming Ruby 1.9'
  end
end

