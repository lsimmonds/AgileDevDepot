class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
    @orders = Order.paginate page: params[:page], order: 'created_at desc',
      per_page: 10

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    redirect_to store_url, notice: 'Invalid order' if @order_not_found
  end

  # GET /orders/new
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      return
    end

    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        OrderNotifier.received(@order).deliver
        format.html { redirect_to store_url, notice: 'Thank you for your order.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        Cart.destroy(session[:cart_id])
        @cart = current_cart
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    if @order_not_found
      redirect_to store_url, notice: 'Invalid order'
    else
      @order.attributes = order_params
      @order["ship_date"] = DateTime.now
      ship_date_changed = @order.ship_date_changed?
      respond_to do |format|
        if @order.save
          OrderNotifier.shipped(@order).deliver if ship_date_changed
          format.html { redirect_to @order, :notice => 'Order was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @order.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      begin
        @order = Order.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error "Attempt to access invalid order #{params[:id]}"
        AdminNotifier.not_found_error(params).deliver
        @order_not_found = true
      else
        @order_not_found = false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:id, :name, :address, :email, :pay_type_id, :ship_date)
    end
end
