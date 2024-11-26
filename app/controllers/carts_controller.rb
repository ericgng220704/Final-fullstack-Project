class CartsController < ApplicationController
  def show
    # Retrieve product details for all items in the cart
    @cart_items = session[:cart]&.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity.to_i } if product
    end&.compact || []
  end

  def add_to_cart
    session[:cart] ||= {}
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    # Increment or set the quantity
    session[:cart][product_id] = (session[:cart][product_id] || 0) + quantity

    redirect_to cart_path, notice: "Product added to cart!"
  end

  def update_item
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    if quantity > 0
      session[:cart][product_id] = quantity
    else
      session[:cart].delete(product_id)
    end

    redirect_to cart_path, notice: "Cart updated!"
  end

  def remove_item
    product_id = params[:product_id].to_s
    session[:cart].delete(product_id)

    redirect_to cart_path, notice: "Item removed from cart!"
  end

  def clear_cart
    session[:cart] = {}
    redirect_to cart_path, notice: "Cart cleared!"
  end
end
