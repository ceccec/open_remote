##
# Seed helpers for the `User` model.
#
# This concern centralizes all seeding logic so `db/seeds.rb` stays thin.
#
# Security principles (Rails Guides aligned):
# - Never hardcode production credentials in seeds.
# - Prefer environment variables / credentials for configuration.
# - If a password is generated, only display it at seed-time (do not write to files).
#
module User::Seedable
  extend ActiveSupport::Concern

  DEFAULT_ROLES = %w[admin manager viewer].freeze

  class_methods do
    ##
    # Ensure default roles exist.
    #
    # @return [void]
    def ensure_default_roles!
      DEFAULT_ROLES.each { |role_name| Role.find_or_create_by!(name: role_name) }
    end

    ##
    # Generate a secure random password.
    #
    # @param length [Integer] desired password length (default: 16, min: 12)
    # @return [String]
    def generate_secure_password(length: 16)
      length = [ length, 12 ].max

      lowercase = ("a".."z").to_a
      uppercase = ("A".."Z").to_a
      numbers   = ("0".."9").to_a
      special   = %w[! @ # $ % ^ & * - _ + =]

      password = [
        lowercase.sample,
        uppercase.sample,
        numbers.sample,
        special.sample
      ]

      all_chars = lowercase + uppercase + numbers + special
      (length - 4).times { password << all_chars.sample }

      password.shuffle.join
    end

    ##
    # Ensure the "super admin" user exists and is correctly configured.
    #
    # Behavior:
    # - If the user is new: sets a password (provided or generated).
    # - If the user exists: does NOT change the password unless `password:` is explicitly provided.
    # - Always ensures: admin flag, :admin role, confirmed, and unlocked.
    #
    # @param email [String]
    # @param password [String, nil] optional password (opt-in rotation when user exists)
    # @return [User]
    def ensure_super_admin!(email:, password: nil)
      user = find_or_initialize_by(email: email)

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

      # Confirmable
      user.confirmed_at ||= Time.current
      user.confirmation_token = nil
      user.confirmation_sent_at = nil

      # Lockable
      user.failed_attempts = 0
      user.locked_at = nil
      user.unlock_token = nil

      user.save!

      # Ensure admin role + admin flag (rolify + backward-compatible boolean)
      user.make_admin! unless user.has_role?(:admin)

      # Double-check confirmed? (clears token via update_columns if needed)
      user.confirm! unless user.confirmed?

      user.reload

      # Only return the user; printing is the seed's responsibility.
      # Return password_to_set as a virtual attribute for callers that want to display it.
      user.define_singleton_method(:seed_password_to_set) { password_to_set }

      user
    end
  end
end
