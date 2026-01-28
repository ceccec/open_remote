##
# Remember me functionality.
# Allows users to stay logged in across browser sessions.
#
module User::Rememberable
  extend ActiveSupport::Concern

  ##
  # Generate a remember token and set expiration.
  #
  # @return [String] the remember token
  def remember_me!
    generate_remember_token!
    update_column(:remember_created_at, Time.current)
    remember_token
  end

  ##
  # Clear the remember token.
  #
  # @return [void]
  def forget_me!
    update_columns(
      remember_token: nil,
      remember_created_at: nil
    )
  end

  ##
  # Check if remember token is valid and not expired.
  #
  # @return [Boolean]
  def remember_token_valid?
    return false unless remember_token.present?
    return false unless remember_created_at.present?

    remember_created_at > 2.weeks.ago
  end

  private

  ##
  # Generate a unique remember token.
  #
  # @return [void]
  def generate_remember_token!
    loop do
      self.remember_token = SecureRandom.urlsafe_base64(32)
      break unless self.class.exists?(remember_token: remember_token)
    end
    save(validate: false)
  end
end
