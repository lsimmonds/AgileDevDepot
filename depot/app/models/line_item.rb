class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart

  def total_price
    price * quantity
  end

  def decrement
    self.quantity -= 1 if self.quantity > 0
  end

  private
    def line_item_params
      params.require(:line_item).permit(:cart_id, :product_id)
    end
end
