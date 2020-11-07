class ProductsController < ApplicationController
  before_action :set_product, except: [:index, :new, :create, :get_category_children, :get_category_grandchildren]

  def index
    @products = Product.includes(:images).order("created_at DESC")
  end

  def new
    @product = Product.new
    @product.images.build
    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent
    end
  end

  def get_category_children
    category = Category.find(params[:parent_id])
    @category_children = category.children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:child_id]).children
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new 
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

    def product_params
      params.require(:product).permit(:name, :explanation, :category_id, :status_id, :delivery_fee_id, :shipping_area_id, :shipping_day_id, :price, images_attributes: [:image])
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
