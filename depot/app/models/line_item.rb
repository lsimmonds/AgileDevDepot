class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  def total_price
    price * quantity
  end

  private
    def line_item_params
      params.require(:line_item).permit(:cart_id, :product_id)
    end
end
