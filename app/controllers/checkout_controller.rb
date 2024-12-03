class CheckoutController < ApplicationController
  include TaxHelper

  def create
    session[:cart] ||= {}
    cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      {
        price_data: {
          currency: 'cad',
          product_data: {
            name: product.name,
          },
          unit_amount: (product.price * 100).to_i,
        },
        quantity: quantity,
        product: product,
        quantity_value: quantity
      }
    end

    if cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add items before proceeding to checkout."
      return
    end

    # Calculate subtotal, tax, and total
    subtotal = session[:cart].sum do |product_id, quantity|
      product = Product.find(product_id)
      product.price * quantity
    end

    # Ensure the user has a valid province
    if current_user&.province.blank?
      redirect_to cart_path, alert: "Please update your profile with your province to calculate taxes."
      return
    end

    tax = TaxHelper.calculate_tax(subtotal, current_user.province)
    tax_rate = TaxHelper.get_tax_rate(current_user.province)
    total = subtotal + tax

    # Create a new order for the current user
    order = current_user.orders.build(
      order_date: Time.current,
      status: "unpaid",
      total_amount: total,
      tax_rate: tax_rate

    )

    # Add items to the order
    cart_items.each do |item|
      order.order_items.build(
        product_id: item[:product].id,
        quantity: item[:quantity_value],
        price_at_purchase: item[:product].price
      )
    end

    if order.save

      # Add a "tax" item to the Stripe Checkout Session
      stripe_items = cart_items.map do |item|
        {
          price_data: item[:price_data],
          quantity: item[:quantity_value]
        }
      end

      stripe_items << {
        price_data: {
          currency: 'cad',
          product_data: {
            name: "Tax (#{current_user.province})",
          },
          unit_amount: (tax * 100).to_i, # Amount in cents
        },
        quantity: 1,
      }

      # Create Stripe Checkout Session
      checkout_session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: stripe_items,
        mode: 'payment',
        success_url: checkout_success_url(order_id: order.id),
        cancel_url: cart_url,
      )

      render json: { id: checkout_session.id }
    else
      Rails.logger.debug "Order save failed: #{order.errors.full_messages}"
      redirect_to cart_path, alert: "Could not create your order. Please try again."
    end
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error: #{e.message}"
    redirect_to cart_path, alert: "Something went wrong with Stripe. Please try again."
  end

  def success
    session[:cart] = {}
    @order = current_user.orders.find(params[:order_id])

    if @order.update(status: 'paid')
      redirect_to order_path(@order), notice: "Payment successful! Order ##{@order.id} has been created."
    else
      redirect_to cart_path, alert: "Payment succeeded, but we could not update your order. Please contact support."
    end
  end

  def cancel
    flash[:alert] = "Payment was canceled. You can try again."
    redirect_to cart_path
  end
end
