##
# Enable TimescaleDB extension.
# Only runs when TIMESCALEDB_ENABLED=true environment variable is set.
# Note: Hypertable conversion happens in a later migration after data_points table is created.
#
class EnableTimescaledbExtension < ActiveRecord::Migration[8.1]
  def up
    return unless ENV["TIMESCALEDB_ENABLED"] == "true"

    execute "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;" unless extension_enabled?("timescaledb")
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.warn "TimescaleDB not available: #{e.message}"
  end

  def down
    # Note: Dropping extension should be done carefully
    # Hypertable conversion will be reverted by the later migration first
    execute "DROP EXTENSION IF EXISTS timescaledb CASCADE;"
  end

  private

  def extension_enabled?(name)
    result = connection.execute(
      "SELECT EXISTS(SELECT 1 FROM pg_extension WHERE extname = '#{name}');"
    )
    result.first["exists"]
  end
end
