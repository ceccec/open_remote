##
# User registration controller.
# Handles user signup and account creation.
#
class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create ]

  ##
  # Show registration form.
  #
  # @return [void]
  def new
    @user = User.new
  end

  ##
  # Create a new user account.
  # Sends confirmation email after successful creation.
  #
  # @return [void]
  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_confirmation_instructions
      redirect_to main_app.login_path, notice: "Registration successful! Please check your email to confirm your account."
    else
      render :new, status: :unprocessable_content
    end
  end

  ##
  # Show account edit form for current user.
  #
  # @return [void]
  def edit
    @user = current_user
  end

  ##
  # Update current user's account.
  #
  # @return [void]
  def update
    @user = current_user

    if @user.update(user_update_params)
      redirect_to main_app.root_path, notice: "Account updated successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  ##
  # Strong parameters for user creation.
  #
  # @return [ActionController::Parameters]
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  ##
  # Strong parameters for user updates.
  #
  # @return [ActionController::Parameters]
  def user_update_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
