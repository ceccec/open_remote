class EnableTimescaledbAndCreateHypertable < ActiveRecord::Migration[8.1]
  def up
    # Only attempt TimescaleDB setup when explicitly enabled.
    # This avoids breaking migrations on environments without TimescaleDB installed.
    return unless ENV["TIMESCALEDB_ENABLED"] == "true"

    # Enable TimescaleDB extension (requires superuser privileges)
    # Note: This will fail if TimescaleDB is not installed
    # In production, this should be done by a database admin
    execute 'CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;' unless extension_enabled?('timescaledb')

    # Convert data_points table to hypertable
    # This optimizes the table for time-series data
    execute <<-SQL
      SELECT create_hypertable('data_points', 'timestamp',
        chunk_time_interval => INTERVAL '1 day',
        if_not_exists => TRUE
      );
    SQL
  rescue ActiveRecord::StatementInvalid => e
    # If TimescaleDB is not available, log a warning but don't fail
    Rails.logger.warn "TimescaleDB not available: #{e.message}"
    Rails.logger.warn "Data points table will work without TimescaleDB optimization"
  end

  def down
    # Note: Dropping hypertable and extension should be done carefully
    # This is a destructive operation
    execute 'DROP EXTENSION IF EXISTS timescaledb CASCADE;'
  end

  private

  def extension_enabled?(name)
    result = connection.execute(
      "SELECT EXISTS(SELECT 1 FROM pg_extension WHERE extname = '#{name}');"
    )
    result.first['exists']
  end
end
