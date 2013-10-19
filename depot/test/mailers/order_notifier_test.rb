require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  setup do
    @order = orders(:one)
    @order.line_items << line_items(:one)
    @order.line_items[0].product = products(:one)
  end

  test "received" do
    mail = OrderNotifier.received(@order)
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    #assert_equal ["dave@example.org"], mail.to
    #assert_equal ["depot@example.com"], mail.from
    assert_match /1 x MyString/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(@order)
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    #assert_equal ["dave@example.org"], mail.to
    #assert_equal ["depot@example.com"], mail.from
    assert_match /<td>1&times;<\/td>\s*<td>MyString<\/td>/,
      mail.body.encoded
  end

end
