# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require "securerandom"

##
# Generate a secure random password.
# Creates a password with mixed case, numbers, and special characters.
#
# @param length [Integer] desired password length (default: 16)
# @return [String] secure random password
def generate_secure_password(length: 16)
  # Ensure minimum length for security
  length = [length, 12].max

  # Character sets
  lowercase = ("a".."z").to_a
  uppercase = ("A".."Z").to_a
  numbers = ("0".."9").to_a
  special = %w[! @ # $ % ^ & * - _ + =]

  # Ensure at least one character from each set
  password = [
    lowercase.sample,
    uppercase.sample,
    numbers.sample,
    special.sample
  ]

  # Fill the rest with random characters from all sets
  all_chars = lowercase + uppercase + numbers + special
  (length - 4).times { password << all_chars.sample }

  # Shuffle to avoid predictable pattern
  password.shuffle.join
end

DEFAULT_ROLES = %w[admin manager viewer].freeze

def ensure_default_roles!
  DEFAULT_ROLES.each { |role_name| Role.find_or_create_by!(name: role_name) }
  puts "✓ Default roles created: #{DEFAULT_ROLES.join(', ')}"
end

def ensure_super_admin!(email:, password: nil)
  # Only set a password if:
  # - the user is new, OR
  # - SUPER_ADMIN_PASSWORD is explicitly provided (opt-in rotation)
  user = User.find_or_initialize_by(email: email)

  password_to_set =
    if user.new_record?
      password.presence || generate_secure_password(length: 16)
    elsif password.present?
      password
    end

  if password_to_set.present?
    user.password = password_to_set
    user.password_confirmation = password_to_set
  end

  # Ensure core flags/attributes are correct and idempotent.
  user.admin = true

  # Confirmation (Confirmable):
  # - confirmed_at must be present
  # - confirmation_token/sent_at should be nil once confirmed
  user.confirmed_at ||= Time.current
  user.confirmation_token = nil
  user.confirmation_sent_at = nil

  # Lockable:
  user.failed_attempts = 0
  user.locked_at = nil
  user.unlock_token = nil

  user.save!

  # Ensure admin role + admin flag (rolify + backward-compatible boolean)
  user.make_admin! unless user.has_role?(:admin)

  # Double-check confirmed? (clears token via update_columns if needed)
  user.confirm! unless user.confirmed?

  user.reload

  puts "✓ Super admin user ensured:"
  puts "  Email: #{user.email}"
  puts "  Admin role: #{user.has_role?(:admin) ? '✓' : '✗'}"
  puts "  Admin flag: #{user.admin? ? '✓' : '✗'}"
  puts "  Confirmed: #{user.confirmed? ? '✓' : '✗'}"
  puts "  Account locked: #{user.access_locked? ? '✓' : '✗'}"

  if password_to_set.present?
    puts "  Password: #{password_to_set}"
    puts "  ⚠️  Save this password securely (only shown when set)."
  else
    puts "  Password: [unchanged]"
  end
end

ensure_default_roles!

# Create default admin user (development and test only)
# WARNING: Never add default credentials to production seeds!
# Email can be configured via SUPER_ADMIN_EMAIL environment variable
if Rails.env.development? || Rails.env.test?
  super_admin_email = ENV.fetch("SUPER_ADMIN_EMAIL", "admin@openremote.local")
  super_admin_password = ENV["SUPER_ADMIN_PASSWORD"]

  ensure_super_admin!(email: super_admin_email, password: super_admin_password)

  puts "  (development/test only)"
else
  puts "⚠️  Skipping default admin user creation in #{Rails.env} environment"
  puts "   Create admin users manually or via Rails console"
end
