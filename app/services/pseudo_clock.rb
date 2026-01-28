require "time"

##
# Simple pseudo clock mirroring the behaviour tested in OpenRemote's
# `TimerService.Clock.PSEUDO` JUnit tests.
#
# Internally the clock keeps time as milliseconds since the Unix epoch.
class PseudoClock
  ##
  # @return [Integer] current time in milliseconds since epoch
  attr_reader :current_time_millis

  def initialize
    @current_time_millis = 0
  end

  ##
  # Set the clock using a date, a Ruby `Time` for the time-of-day, and a
  # symbolic zone identifier such as `"UTC"` or `"CET"`.
  #
  # @param date [Date] calendar date
  # @param time_of_day [Time] time-of-day (only hour/min/sec are used)
  # @param zone_id [String] timezone identifier ("UTC", "CET", ...)
  # @return [void]
  def set_time(date, time_of_day, zone_id)
    offset = zone_offset_for(zone_id)
    time = Time.new(
      date.year, date.month, date.day,
      time_of_day.hour, time_of_day.min, time_of_day.sec,
      offset
    )
    @current_time_millis = (time.to_r * 1000).to_i
  end

  ##
  # Set the clock from an ISO-8601 timestamp string.
  #
  # @param iso_timestamp [String] ISO-8601 timestamp with offset
  # @return [void]
  def set_time_iso(iso_timestamp)
    time = Time.iso8601(iso_timestamp)
    @current_time_millis = (time.to_r * 1000).to_i
  end

  private

  def zone_offset_for(zone_id)
    case zone_id
    when "UTC" then "+00:00"
    when "CET" then "+01:00"
    else "+00:00"
    end
  end
end
