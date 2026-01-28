##
# Recurring job to clean up old data points.
#
# This job should be scheduled to run periodically (e.g., daily)
# to remove data points older than the retention period.
class DatapointCleanupJob < ApplicationJob
  queue_as :default

  ##
  # Clean up data points older than the retention period.
  #
  # @param older_than_days [Integer] number of days to retain (default: 90)
  # @return [void]
  def perform(older_than_days: 90)
    deleted_count = AssetDatapointService.cleanup_old_datapoints(older_than: older_than_days.days)
    Rails.logger.info "DatapointCleanupJob: Deleted #{deleted_count} old data point(s)" if deleted_count > 0
  end
end
