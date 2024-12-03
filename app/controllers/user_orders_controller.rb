# app/controllers/user_orders_controller.rb
class UserOrdersController < ApplicationController
  before_action :authenticate_user!

  def cancel
    @order = current_user.orders.find(params[:id])

    if @order.cancelable?
      @order.update(status: 'canceled')
      redirect_to orders_path, notice: 'Order canceled successfully.'
    else
      redirect_to orders_path, alert: 'Order cannot be canceled at this stage.'
    end
  end

  def confirm
    @order = current_user.orders.find(params[:id])

    if @order.status == 'delivered'
      @order.update(status: 'completed')
      redirect_to orders_path, notice: 'Thank you for confirming! Your order is now marked as completed.'
    else
      redirect_to orders_path, alert: 'Only delivered orders can be marked as completed.'
    end
  end
end
