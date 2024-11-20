class ProductsController < ApplicationController
  def index
    @products = Product.page(params[:page]).per(10) # Pagination
  end

  def show
    @product = Product.find(params[:id])
  end
end
