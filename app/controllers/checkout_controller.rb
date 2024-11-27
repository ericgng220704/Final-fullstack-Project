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
          unit_amount: (product.price * 100).to_i, # Amount in cents
        },
        quantity: quantity,
      }
    end

    if cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add items before proceeding to checkout."
      return
    end

    # Calculate the subtotal, tax, and total
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
    total = subtotal + tax

    # Add a "tax" item to the Stripe Checkout Session
    cart_items << {
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
      line_items: cart_items,
      mode: 'payment',
      success_url: checkout_success_url,
      cancel_url: cart_url,
    )

    render json: { id: checkout_session.id }
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error: #{e.message}"
    redirect_to cart_path, alert: "Something went wrong with Stripe. Please try again."
  end

  def success
    # Ensure the user is logged in before creating an order
    if user_signed_in?
      cart_items = session[:cart].map do |product_id, quantity|
        product = Product.find(product_id)
        { product: product, quantity: quantity }
      end

      # Calculate subtotal and tax for the order
      subtotal = cart_items.sum { |item| item[:product].price * item[:quantity] }
      tax = TaxHelper.calculate_tax(subtotal, current_user.province)
      total = subtotal + tax

      Rails.logger.debug "Cart Items: #{cart_items.inspect}"

      # Create a new order for the current user
      order = current_user.orders.build(
        order_date: Time.current,
        status: "completed",
        subtotal: subtotal,
        tax: tax,
        total_amount: total
      )

      # Add items to the order
      cart_items.each do |item|
        order.order_items.build(
          product_id: item[:product].id,
          quantity: item[:quantity],
          price_at_purchase: item[:product].price
        )
      end

      if order.save
        session[:cart] = {} # Clear the cart after saving the order
        redirect_to order_path(order), notice: "Your payment was successful! Order ##{order.id} has been created."
      else
        Rails.logger.debug "Order save failed: #{order.errors.full_messages}"
        redirect_to cart_path, alert: "Payment succeeded, but we could not create your order. Please contact support."
      end
    else
      redirect_to new_user_session_path, alert: "Please log in to complete your purchase."
    end
  end

  def cancel
    flash[:alert] = "Payment was canceled. You can try again."
    redirect_to cart_path
  end
end
