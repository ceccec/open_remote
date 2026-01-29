##
# User model with Devise-like authentication features.
# Includes: confirmable, recoverable, rememberable, lockable
#
class User < ApplicationRecord
  include TestExpectations

  rolify
  has_secure_password

  # Include authentication concerns
  include User::Confirmable
  include User::Recoverable
  include User::Rememberable
  include User::Lockable
  include User::Seedable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # Feature declarations
  feature :validates, :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  feature :validates, :password, length: { minimum: 6 }
  feature :provides, :admin?, :make_admin!, :remove_admin!, :confirmed?, :confirm!, :send_confirmation_instructions,
           :remember_me!, :forget_me!, :remember_token_valid?, :send_reset_password_instructions,
           :reset_password, :reset_password_period_valid?, :access_locked?, :lock_access!, :unlock_access!,
           :increment_failed_attempts!, :send_unlock_instructions

  has_paper_trail

  # Scopes for common queries
  # Indexed: confirmed_at, locked_at, admin
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :unconfirmed, -> { where(confirmed_at: nil) }
  scope :locked, -> { where.not(locked_at: nil) }
  scope :unlocked, -> { where(locked_at: nil) }
  scope :with_role, ->(role_name) { joins(:roles).where(roles: { name: role_name }) }
  scope :admins, -> { where(admin: true).or(with_role(:admin)) }

  ##
  # Find user by reset password token.
  #
  # @param token [String] reset password token
  # @return [User, nil]
  def self.find_by_reset_password_token(token)
    find_by(reset_password_token: token)
  end

  ##
  # Find user by confirmation token.
  #
  # @param token [String] confirmation token
  # @return [User, nil]
  def self.find_by_confirmation_token(token)
    find_by(confirmation_token: token)
  end

  ##
  # Find user by remember token.
  #
  # @param token [String] remember token
  # @return [User, nil]
  def self.find_by_remember_token(token)
    find_by(remember_token: token) if token.present?
  end

  ##
  # Find user by unlock token.
  #
  # @param token [String] unlock token
  # @return [User, nil]
  def self.find_by_unlock_token(token)
    find_by(unlock_token: token)
  end

  ##
  # Check if user has admin role.
  # Maintains backward compatibility with admin flag.
  #
  # @return [Boolean] true if user has admin flag or admin role
  # @example Check if user is admin
  #   user = User.find_by(email: "admin@example.com")
  #   user.admin? # => true
  # @see spec/models/user_spec.rb User admin flag
  def admin?
    admin || has_role?(:admin)
  end

  ##
  # Add admin role to user.
  #
  # @return [void]
  def make_admin!
    add_role(:admin) unless has_role?(:admin)
    update_column(:admin, true) unless admin
  end

  ##
  # Remove admin role from user.
  #
  # @return [void]
  def remove_admin!
    remove_role(:admin) if has_role?(:admin)
    update_column(:admin, false) if admin
  end
end
