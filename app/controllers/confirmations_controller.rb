##
# Email confirmation controller.
# Handles email confirmation and resending confirmation emails.
#
class ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :new, :create ]

  # Rate limit confirmation resend requests to prevent abuse
  rate_limit to: 5, within: 15.minutes, only: :create

  ##
  # Confirm user's email address using confirmation token.
  #
  # @return [void]
  def show
    @token = params[:confirmation_token]
    @user = User.find_by_confirmation_token(@token)

    if @user&.confirmation_period_valid?
      @user.confirm!
      redirect_to main_app.login_path, notice: "Your email has been confirmed. You can now log in."
    else
      redirect_to main_app.new_confirmation_path, alert: "Confirmation token is invalid or has expired."
    end
  end

  ##
  # Show resend confirmation instructions form.
  #
  # @return [void]
  def new
    @user = User.new
  end

  ##
  # Resend confirmation instructions via email.
  # Does not reveal whether email exists for security.
  #
  # @return [void]
  def create
    @user = User.find_by(email: params[:user][:email])

    if @user
      if @user.confirmed?
        redirect_to main_app.login_path, notice: "Email already confirmed. You can log in."
      else
        @user.send_confirmation_instructions
        redirect_to main_app.login_path, notice: "Confirmation instructions have been sent to your email."
      end
    else
      # Don't reveal if email exists (security best practice)
      redirect_to main_app.login_path, notice: "If an account exists with that email, confirmation instructions have been sent."
    end
  end
end
