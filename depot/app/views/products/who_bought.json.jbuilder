json.extract! @product, :title, :price

json.orders @product.orders do |json, order|
  json.title "Order #{order.id}"
  json.shipped_to "#{order.address}"

  json.product order.line_items do |json, line_item|
    json.title line_item.product.title
    json.quantity line_item.quantity
    json.price line_item.price
  end

  json.total order.line_items.map(&:total_price).sum
  json.payment_type order.pay_type

  json.author do
    json.name order.name
    json.email_address order.email
  end
end
