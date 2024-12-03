# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in

  # Show current user's profile
  def show
    @user = current_user
    @orders = @user.orders
  end

  # Edit current user's profile
  def edit
    @user = current_user
  end

  # Update current user's profile
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit, alert: 'Error updating profile.'
    end
  end

  private

  # Strong parameters for user updates
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
