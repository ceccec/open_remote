##
# Email confirmation functionality.
# Allows users to confirm their email addresses before accessing the system.
#
module User::Confirmable
  extend ActiveSupport::Concern

  included do
    before_create :generate_confirmation_token, unless: :confirmed?
  end

  ##
  # Check if user's email is confirmed.
  #
  # @return [Boolean] true if email is confirmed
  # @example Check confirmation status
  #   user = User.find_by(email: "user@example.com")
  #   user.confirmed? # => false (before confirmation)
  #   user.confirm!
  #   user.confirmed? # => true
  def confirmed?
    confirmed_at.present?
  end

  ##
  # Mark user's email as confirmed.
  #
  # @return [Boolean] true if confirmation was successful
  def confirm!
    return true if confirmed?

    update_columns(
      confirmed_at: Time.current,
      confirmation_token: nil
    )
  end

  ##
  # Generate a new confirmation token and send confirmation email.
  #
  # @return [String] the confirmation token
  def send_confirmation_instructions
    generate_confirmation_token! unless confirmation_token.present?
    update_column(:confirmation_sent_at, Time.current)
    UserMailer.confirmation_instructions(self).deliver_later
    confirmation_token
  end

  ##
  # Check if confirmation token is valid and not expired.
  #
  # @param token [String] the confirmation token
  # @return [Boolean]
  def confirmation_period_valid?
    return false unless confirmation_sent_at.present?

    confirmation_sent_at > 24.hours.ago
  end

  private

  ##
  # Generate a unique confirmation token.
  #
  # @return [void]
  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64(32)
  end

  ##
  # Generate a new confirmation token, overwriting any existing one.
  #
  # @return [void]
  def generate_confirmation_token!
    loop do
      self.confirmation_token = SecureRandom.urlsafe_base64(32)
      break unless self.class.exists?(confirmation_token: confirmation_token)
    end
    save(validate: false)
  end
end
