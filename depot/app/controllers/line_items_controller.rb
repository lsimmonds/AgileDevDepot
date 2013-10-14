class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :edit, :update, :destroy, :decrement]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    if @line_item_not_found
      redirect_to store_url, notice: 'Invalid line item'
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @cart }
      end
    end
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
    @line_item.product = product
    session[:counter] = 0

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        format.js { @current_item = @line_item }
        format.json { render action: 'show', status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    if @line_item_not_found
      redirect_to store_url, notice: 'Invalid line item'
    else
      respond_to do |format|
        if @line_item.update(line_item_params)
          format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @line_item.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    if @line_item_not_found
      redirect_to store_url, notice: 'Invalid line item'
    else
      @line_item.destroy
      redir_dest = @line_item.cart.nil? ? store_url : @line_item.cart
      respond_to do |format|
        format.html { redirect_to redir_dest }
        format.json { head :no_content }
      end
    end
  end

  def decrement
    @cart = current_cart
    if @line_item_not_found
      redirect_to store_url, notice: 'Invalid line item'
    else
      @line_item.decrement
      if @line_item.quantity < 1
        @line_item.destroy
      else
        respond_to do |format|
          if @line_item.save
            format.html { redirect_to store_url }
            format.js { @current_item = @line_item }
            format.json { render action: 'show', status: :created, location: @line_item }
          else
            format.html { render action: 'new' }
            format.json { render json: @line_item.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      begin
        @line_item = LineItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error "Attempt to access invalid line item #{params[:id]}"
        @line_item_not_found = true
      else
        @line_item_not_found = false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
end
