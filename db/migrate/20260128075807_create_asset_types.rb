class CreateAssetTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :asset_types, id: :uuid do |t|
      t.string :name
      t.string :display_name
      t.text :description
      t.string :icon

      t.timestamps
    end
    add_index :asset_types, :name
  end
end
