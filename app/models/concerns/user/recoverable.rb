##
# Password recovery functionality.
# Allows users to reset their passwords via email.
#
module User::Recoverable
  extend ActiveSupport::Concern

  ##
  # Generate a password reset token and send reset instructions.
  #
  # @return [String] the reset token
  def send_reset_password_instructions
    generate_reset_password_token!
    update_column(:reset_password_sent_at, Time.current)
    UserMailer.reset_password_instructions(self).deliver_later
    reset_password_token
  end

  ##
  # Reset password with the provided token.
  #
  # @param password [String] new password (minimum 6 characters)
  # @param password_confirmation [String] password confirmation
  # @return [Boolean] true if reset was successful, false if token invalid/expired or validation failed
  # @example Reset password with valid token
  #   user = User.find_by_reset_password_token(token)
  #   if user.reset_password(password: "newpass123", password_confirmation: "newpass123")
  #     # Password reset successful
  #   end
  def reset_password(password:, password_confirmation:)
    return false unless reset_password_period_valid?

    if update(password: password, password_confirmation: password_confirmation)
      update_columns(
        reset_password_token: nil,
        reset_password_sent_at: nil
      )
      true
    else
      false
    end
  end

  ##
  # Check if reset password token is valid and not expired.
  #
  # @return [Boolean]
  def reset_password_period_valid?
    return false unless reset_password_token.present?
    return false unless reset_password_sent_at.present?

    reset_password_sent_at > 6.hours.ago
  end

  private

  ##
  # Generate a unique password reset token.
  #
  # @return [void]
  def generate_reset_password_token!
    loop do
      self.reset_password_token = SecureRandom.urlsafe_base64(32)
      break unless self.class.exists?(reset_password_token: reset_password_token)
    end
    save(validate: false)
  end
end
