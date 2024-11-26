class CheckoutController < ApplicationController
  def create
    session[:cart] ||= {}
    cart_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)
      {
        price_data: {
          currency: 'usd',
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
end
