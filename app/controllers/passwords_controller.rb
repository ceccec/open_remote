##
# Password reset controller.
# Handles password reset requests and password updates.
#
class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create, :edit, :update ]

  # Rate limit password reset requests to prevent abuse
  rate_limit to: 5, within: 15.minutes, only: :create

  ##
  # Show password reset request form.
  #
  # @return [void]
  def new
    @user = User.new
  end

  ##
  # Send password reset instructions via email.
  # Does not reveal whether email exists for security.
  #
  # @return [void]
  def create
    @user = User.find_by(email: params[:user][:email])

    if @user
      @user.send_reset_password_instructions
      redirect_to main_app.login_path, notice: "Password reset instructions have been sent to your email."
    else
      # Don't reveal if email exists (security best practice)
      redirect_to main_app.login_path, notice: "If an account exists with that email, password reset instructions have been sent."
    end
  end

  ##
  # Show password reset form with token validation.
  #
  # @return [void]
  def edit
    @token = params[:reset_password_token]
    @user = User.find_by_reset_password_token(@token)

    unless @user&.reset_password_period_valid?
      redirect_to main_app.new_password_path, alert: "Password reset token is invalid or has expired."
    end
  end

  ##
  # Update password using reset token.
  #
  # @return [void]
  def update
    @token = params[:reset_password_token]
    @user = User.find_by_reset_password_token(@token)

    unless @user&.reset_password_period_valid?
      redirect_to main_app.new_password_path, alert: "Password reset token is invalid or has expired."
      return
    end

    if @user.reset_password(
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation]
    )
      redirect_to main_app.login_path, notice: "Password has been reset successfully."
    else
      render :edit, status: :unprocessable_content
    end
  end
end
