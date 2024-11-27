class ProductsController < ApplicationController
  def index
    # Fetch all products
    @products = Product.all

    # Filter by category if parameter is provided
    @products = @products.by_category(params[:category]) if params[:category].present?

    # Apply additional filters
    if params[:filter] == 'new'
      @products = @products.new_products
    elsif params[:filter] == 'recently_updated'
      @products = @products.recently_updated
    end

    # Apply keyword search
    @products = @products.search(params[:query]) if params[:query].present?

    # Paginate using Kaminari
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end
