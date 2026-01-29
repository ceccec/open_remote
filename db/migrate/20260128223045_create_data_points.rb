##
# Create data_points table.
# Time-series measurements captured for assets.
# Converts to TimescaleDB hypertable if extension is enabled.
#
class CreateDataPoints < ActiveRecord::Migration[8.1]
  def change
    create_table :data_points, id: :uuid do |t|
      t.references :asset, null: false, foreign_key: true, type: :uuid
      t.string :attribute_name, null: false
      t.jsonb :value, null: false
      t.datetime :timestamp, null: false

      t.timestamps
    end

    # Indexes for queries
    # Note: asset_id index is automatically created by t.references
    add_index :data_points, :attribute_name
    add_index :data_points, :timestamp

    # Composite index for common query patterns (asset + attribute + timestamp)
    add_index :data_points, [ :asset_id, :attribute_name, :timestamp ], name: "index_data_points_on_asset_attr_time"

    # Convert to TimescaleDB hypertable if extension is enabled
    reversible do |direction|
      direction.up do
        if ENV["TIMESCALEDB_ENABLED"] == "true" && extension_enabled?("timescaledb")
          execute <<-SQL
            SELECT create_hypertable('data_points', 'timestamp',
              chunk_time_interval => INTERVAL '1 day',
              if_not_exists => TRUE
            );
          SQL
        end
      end
      direction.down do
        # TimescaleDB will handle hypertable cleanup when extension is dropped
        # No explicit action needed here
      end
    end
  end

  private

  def extension_enabled?(name)
    result = connection.execute(
      "SELECT EXISTS(SELECT 1 FROM pg_extension WHERE extname = '#{name}');"
    )
    result.first["exists"]
  end
end
