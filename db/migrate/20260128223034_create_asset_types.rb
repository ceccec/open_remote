##
# Create asset_types table.
# Asset types define the schema and behavior for different asset categories.
#
class CreateAssetTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :asset_types, id: :uuid do |t|
      t.string :name, null: false
      t.string :display_name
      t.text :description
      t.string :icon

      t.timestamps
    end

    add_index :asset_types, :name, unique: true
  end
end
