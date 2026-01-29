##
# Create roles table for Rolify.
# Supports resource-scoped roles (e.g., manager of a specific asset).
#
class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles, id: :uuid do |t|
      t.string :name, null: false
      t.references :resource, type: :uuid, polymorphic: true, index: { name: "index_roles_on_resource" }

      t.timestamps
    end

    # Composite unique index for scoped uniqueness validation
    # This enforces uniqueness at the database level as recommended by Rails guide
    add_index :roles, [ :name, :resource_type, :resource_id ], unique: true
    add_index :roles, :name
  end
end
