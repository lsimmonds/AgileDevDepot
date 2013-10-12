class StoreController < ApplicationController
  def index
    session[:counter] = 0 if session[:counter].nil?
    @products = Product.order(:title)
    @cart = current_cart
    session[:counter]+=1
  end
end
