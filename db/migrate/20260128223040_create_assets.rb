##
# Create assets table.
# Assets are hierarchical entities that can have a parent and children.
#
class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets, id: :uuid do |t|
      t.string :name, null: false
      t.references :asset_type, null: false, foreign_key: true, type: :uuid, index: true
      t.uuid :parent_id
      t.jsonb :attributes_data, default: {}

      t.timestamps
    end

    add_foreign_key :assets, :assets, column: :parent_id, type: :uuid

    # Indexes for queries
    add_index :assets, :name
    add_index :assets, :parent_id
  end
end
