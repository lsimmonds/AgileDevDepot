class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    if @product_not_found
      redirect_to store_url, notice: 'Invalid product'
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @cart }
      end
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    if @product_not_found
      redirect_to store_url, notice: 'Invalid product'
    else
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to @product, notice: 'Product was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if @product_not_found
      redirect_to store_url, notice: 'Invalid product'
    else
      @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      begin
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.error "Attempt to access invalid product #{params[:id]}"
        @product_not_found = true
      else
        @product_not_found = false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price)
    end
end
