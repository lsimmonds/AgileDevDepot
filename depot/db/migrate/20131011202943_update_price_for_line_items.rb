class UpdatePriceForLineItems < ActiveRecord::Migration
  def up
    LineItem.where("price == 0.00").each do |line_item|
      product = Product.find(line_item.product_id)
      line_item.price = product.price
      line_item.save
    end
  end

  def down
    LineItem.all.each do |line_item|
      line_item.price = 0.00
      line_item.save
    end
  end
end
