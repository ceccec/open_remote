##
# Session controller with Devise-like features.
# Handles login, logout, and remember me functionality.
#
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create ]

  # Rate limit login attempts to prevent brute-force attacks
  rate_limit to: 10, within: 3.minutes, only: :create

  ##
  # Show login form.
  #
  # @return [void]
  def new
    @user = User.new
  end

  ##
  # Authenticate user and create session.
  #
  # @return [void]
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      # Reset session to prevent session fixation attacks
      reset_session
      # Create new session
      session[:user_id] = user.id
      redirect_to "/", notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_content
    end
  end

  ##
  # Destroy user session.
  #
  # @return [void]
  def destroy
    session[:user_id] = nil
    redirect_to "/login", notice: "Logged out successfully"
  end
end
