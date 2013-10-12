require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "Unique products produce separate line items" do
    cart = Cart.create
    cart.add_product(products(:coffee).id)
    cart.save
    assert_equal 1, cart.line_items.count
    assert_in_delta cart.total_price, products(:coffee).price
    cart.add_product(products(:ruby).id)
    cart.save
    assert_equal 2, cart.line_items.count
    assert_in_delta cart.total_price, (products(:coffee).price+products(:ruby).price)
  end

  test "Multiple idenitcal products update a single line item" do
    cart = Cart.create
    cart.add_product(products(:coffee).id)
    cart.save

    cart.add_product(products(:coffee).id)
    cart.save
    assert_equal 1, cart.line_items.count
    assert_in_delta cart.total_price, (products(:coffee).price*cart.line_items[0].quantity)
  end
end
