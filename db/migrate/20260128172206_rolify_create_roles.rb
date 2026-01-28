##
# Migration to create Rolify roles tables.
# Creates:
# - roles table: Stores role definitions (name, optional resource scoping)
# - users_roles join table: Many-to-many relationship between users and roles
#
# Supports resource-scoped roles (e.g., manager of a specific asset).
# Uses UUID primary keys to match application conventions.
#
class RolifyCreateRoles < ActiveRecord::Migration[8.1]
  def change
    # Roles table: stores role definitions
    # - name: role name (e.g., "admin", "manager", "viewer")
    # - resource: optional polymorphic association for resource-scoped roles
    create_table(:roles, id: :uuid) do |t|
      t.string :name, null: false
      t.references :resource, type: :uuid, polymorphic: true

      t.timestamps
    end

    # Join table: many-to-many relationship between users and roles
    # No primary key (id: false) as per Rolify convention
    create_table(:users_roles, id: false) do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :role, type: :uuid, null: false, foreign_key: true
    end

    # Indexes for performance
    # - Composite index on role name and resource for efficient lookups
    # - Unique index on users_roles to prevent duplicate assignments
    # - Index on role name for quick role lookups
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:users_roles, [ :user_id, :role_id ], unique: true)
    add_index(:roles, :name)
  end
end
