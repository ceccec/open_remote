##
# Create users_roles join table for Rolify.
# Many-to-many relationship between users and roles.
#
class CreateUsersRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :users_roles, id: false do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true, index: false
      t.references :role, type: :uuid, null: false, foreign_key: true, index: false
    end

    add_index :users_roles, [ :user_id, :role_id ], unique: true
    add_index :users_roles, :user_id
    add_index :users_roles, :role_id
  end
end
