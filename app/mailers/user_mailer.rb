##
# User mailer for authentication-related emails.
# Sends confirmation, password reset, and unlock instructions.
#
class UserMailer < ApplicationMailer
  ##
  # Send email confirmation instructions.
  #
  # @return [Mail::Message]
  def confirmation_instructions
    @user = params[:user]
    @confirmation_url = confirmation_url(@user.confirmation_token)

    mail(
      to: @user.email,
      subject: "Confirm your account"
    )
  end

  ##
  # Send password reset instructions.
  #
  # @return [Mail::Message]
  def reset_password_instructions
    @user = params[:user]
    @reset_password_url = edit_password_url(@user.reset_password_token)

    mail(
      to: @user.email,
      subject: "Reset your password"
    )
  end

  ##
  # Send account unlock instructions.
  #
  # @return [Mail::Message]
  def unlock_instructions
    @user = params[:user]
    @unlock_url = unlock_url(@user.unlock_token)

    mail(
      to: @user.email,
      subject: "Unlock your account"
    )
  end

  private

  ##
  # Generate confirmation URL for email confirmation link.
  #
  # @param token [String] confirmation token
  # @return [String] confirmation URL
  def confirmation_url(token)
    main_app.confirmation_url(token)
  end

  ##
  # Generate password reset URL for password reset link.
  #
  # @param token [String] reset password token
  # @return [String] password reset URL
  def edit_password_url(token)
    main_app.edit_password_url(token)
  end

  ##
  # Generate unlock URL for account unlock link.
  #
  # @param token [String] unlock token
  # @return [String] unlock URL
  def unlock_url(token)
    main_app.unlock_url(token)
  end
end
