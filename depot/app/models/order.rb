class Order < ActiveRecord::Base
  include ActiveModel::Dirty

  has_many :line_items, dependent: :destroy
  belongs_to :pay_type
  validates :pay_type_id, presence: true

  validates :name, :address, :email, presence: true

  #define_attribute_methods :ship_date

  before_save :set_changed

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  private
    def order_params
      params.require(:order).permit(:address, :email, :name, :pay_type_id)
    end

    def set_changed
      self.ship_date_will_change! unless !self.id.nil? && self.ship_date != Order.find(self.id)
    end
end
