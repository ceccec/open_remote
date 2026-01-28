class CreateDataPoints < ActiveRecord::Migration[8.1]
  def change
    create_table :data_points, id: :uuid do |t|
      t.references :asset, null: false, foreign_key: true, type: :uuid
      t.string :attribute_name, null: false
      t.jsonb :value, null: false
      t.datetime :timestamp, null: false

      t.timestamps
    end
    add_index :data_points, :timestamp
    add_index :data_points, [ :asset_id, :attribute_name, :timestamp ], name: 'index_data_points_on_asset_attr_time'
  end
end
