##
# Create users table with Devise-like authentication fields.
# Includes: password reset, email confirmation, remember me, account locking.
#
class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid do |t|
      # Basic fields
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :admin, default: false, null: false

      # Password reset fields
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      # Email confirmation fields
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      # Remember me fields
      t.string :remember_token
      t.datetime :remember_created_at

      # Account locking fields
      t.integer :failed_attempts, default: 0
      t.string :unlock_token
      t.datetime :locked_at

      t.timestamps
    end

    # Unique indexes for authentication tokens
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    add_index :users, :remember_token, unique: true
    add_index :users, :unlock_token, unique: true

    # Indexes for scopes
    add_index :users, :confirmed_at
    add_index :users, :locked_at
    add_index :users, :admin
  end
end
