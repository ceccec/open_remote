##
# Migration to add Devise-like authentication fields to users table.
# Adds support for:
# - Password reset (reset_password_token, reset_password_sent_at)
# - Email confirmation (confirmation_token, confirmed_at, confirmation_sent_at)
# - Remember me (remember_token, remember_created_at)
# - Account locking (failed_attempts, unlock_token, locked_at)
#
# Note: These fields are Rails-specific and not part of OpenRemote's schema.
# OpenRemote uses Keycloak for authentication, but this Rails app implements
# its own authentication system.
#
class AddDeviseLikeFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    # Password reset fields
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    # Email confirmation fields
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime

    # Remember me fields
    add_column :users, :remember_token, :string
    add_column :users, :remember_created_at, :datetime

    # Account locking fields
    add_column :users, :failed_attempts, :integer, default: 0
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime

    # Add indexes for performance and uniqueness
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :remember_token, unique: true
    add_index :users, :unlock_token, unique: true
  end
end
