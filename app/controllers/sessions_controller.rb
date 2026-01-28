##
# Session controller with Devise-like features.
# Handles login, logout, and remember me functionality.
#
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create ]

  ##
  # Show login form.
  #
  # @return [void]
  def new
    @user = User.new
  end

  ##
  # Authenticate user and create session.
  # Handles account locking, email confirmation, and remember me functionality.
  #
  # @return [void]
  def create
    user = User.find_by(email: params[:email])

    # Check if account is locked (prevents login even with correct password)
    if user&.access_locked?
      flash.now[:alert] = "Your account is locked. Please check your email for unlock instructions."
      render :new, status: :unprocessable_content
      return
    end

    # Check if email is confirmed (required for login)
    unless user&.confirmed?
      flash.now[:alert] = "Please confirm your email address before logging in."
      render :new, status: :unprocessable_content
      return
    end

    if user&.authenticate(params[:password])
      # Reset failed attempts on successful login
      user.update_column(:failed_attempts, 0) if user.failed_attempts&.positive?

      # Handle remember me functionality
      if params[:remember_me] == "1"
        user.remember_me!
        cookies.signed[:remember_token] = {
          value: user.remember_token,
          expires: 2.weeks.from_now,
          httponly: true
        }
      end

      # Create session
      session[:user_id] = user.id
      redirect_to main_app.root_path, notice: "Logged in successfully"
    else
      # Increment failed attempts (may lock account after threshold)
      user&.increment_failed_attempts!
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_content
    end
  end

  ##
  # Destroy user session and clear remember me cookie.
  #
  # @return [void]
  def destroy
    current_user&.forget_me!
    cookies.delete(:remember_token)
    session[:user_id] = nil
    redirect_to main_app.login_path, notice: "Logged out successfully"
  end
end
