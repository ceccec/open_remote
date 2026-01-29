##
# Account unlock controller.
# Handles account unlocking after too many failed login attempts.
#
class UnlocksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :new, :create ]

  # Rate limit unlock requests to prevent abuse
  rate_limit to: 5, within: 15.minutes, only: :create

  ##
  # Unlock user account using unlock token.
  #
  # @return [void]
  def show
    @token = params[:unlock_token]
    @user = User.find_by_unlock_token(@token)

    if @user&.access_locked?
      @user.unlock_access!
      redirect_to main_app.login_path, notice: "Your account has been unlocked. You can now log in."
    else
      redirect_to main_app.new_unlock_path, alert: "Unlock token is invalid or account is not locked."
    end
  end

  ##
  # Show resend unlock instructions form.
  #
  # @return [void]
  def new
    @user = User.new
  end

  ##
  # Resend unlock instructions via email.
  # Does not reveal whether email exists or account status for security.
  #
  # @return [void]
  def create
    @user = User.find_by(email: params[:user][:email])

    if @user&.access_locked?
      @user.send_unlock_instructions
      redirect_to main_app.login_path, notice: "Unlock instructions have been sent to your email."
    else
      # Don't reveal if email exists or account status (security best practice)
      redirect_to main_app.login_path, notice: "If an account exists and is locked, unlock instructions have been sent."
    end
  end
end
