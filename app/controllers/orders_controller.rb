class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :index]
  def show
    @order = current_user.orders.find(params[:id])
  end

  def index
    @orders = current_user.orders
  end
end
