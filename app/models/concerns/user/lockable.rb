##
# Account locking functionality.
# Locks accounts after multiple failed login attempts.
#
module User::Lockable
  extend ActiveSupport::Concern

  MAXIMUM_FAILED_ATTEMPTS = 5
  UNLOCK_IN = 2.hours

  included do
    before_save :reset_failed_attempts!, if: :access_locked?
  end

  ##
  # Check if account is locked.
  #
  # @return [Boolean]
  def access_locked?
    return false unless locked_at.present?

    !lock_expired?
  end

  ##
  # Increment failed login attempts and lock account if threshold reached.
  #
  # @return [void]
  def increment_failed_attempts!
    return if access_locked? # Don't increment if already locked

    new_failed_attempts = (failed_attempts || 0) + 1

    if new_failed_attempts >= MAXIMUM_FAILED_ATTEMPTS
      lock_access!
    else
      update_column(:failed_attempts, new_failed_attempts)
    end
  end

  ##
  # Lock the account.
  #
  # @return [void]
  def lock_access!
    update_columns(
      locked_at: Time.current,
      failed_attempts: MAXIMUM_FAILED_ATTEMPTS
    )
  end

  ##
  # Unlock the account.
  #
  # @return [void]
  def unlock_access!
    update_columns(
      locked_at: nil,
      failed_attempts: 0,
      unlock_token: nil
    )
  end

  ##
  # Generate unlock token and send unlock instructions.
  #
  # @return [String] the unlock token
  def send_unlock_instructions
    generate_unlock_token!
    UserMailer.with(user: self).unlock_instructions.deliver_later
    unlock_token
  end

  private

  ##
  # Check if lock period has expired.
  #
  # @return [Boolean]
  def lock_expired?
    return true unless locked_at.present?
    return false if locked_at.nil?

    locked_at < UNLOCK_IN.ago
  end

  ##
  # Reset failed attempts when saving a locked account.
  # The callback condition ensures this only runs when account is locked.
  #
  # @return [void]
  def reset_failed_attempts!
    # Callback condition already ensures account is locked, so no need to check again
    self.failed_attempts = 0
  end

  ##
  # Generate a unique unlock token.
  #
  # @return [void]
  def generate_unlock_token!
    loop do
      self.unlock_token = SecureRandom.urlsafe_base64(32)
      break unless self.class.exists?(unlock_token: unlock_token)
    end
    save(validate: false)
  end
end
