class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @order = Order.new
    @cart_items = session[:cart]&.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity.to_i } if product
    end&.compact || []
    @total_price = @cart_items.sum { |item| item[:product].price * item[:quantity] }
  end

  def create
    @order = current_user.orders.build(order_params)

    @cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      @order.order_items.build(product: product, quantity: quantity, price: product.price)
    end

    if @order.save
      session[:cart] = {} # Clear the cart after saving the order
      redirect_to checkout_success_path, notice: "Your order was placed successfully!"
    else
      flash.now[:alert] = "There was an issue processing your order. Please try again."
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:address, :phone_number)
  end
end
