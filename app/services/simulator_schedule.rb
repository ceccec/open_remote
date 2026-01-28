##
# Ruby port of the parts of OpenRemote's `SimulatorProtocol.Schedule` that are
# exercised by the mirrored RSpec tests.
#
# Supports simple RFC5545-style RRULEs with:
# - FREQ = DAILY, HOURLY, MINUTELY
# - optional COUNT
# - optional UNTIL=yyyyMMdd'T'HHmmss
# - optional BYHOUR / BYMINUTE for DAILY recurrences.
class SimulatorSchedule
  DEFAULT_REPLAY_LOOP_DURATION = 86_400_000 # 1 day in ms

  attr_reader :start, :end_time, :freq, :by_hour, :by_minute, :until_time, :count, :current, :upcoming

  def initialize(start_time:, end_time: nil, recurrence: nil)
    @start = start_time.utc
    @end_time = end_time&.utc
    parse_recurrence(recurrence)
    @current = nil
    @upcoming = @start
  end

  # Rough equivalent of Java's tryAdvanceActive.
  #
  # @param millis_since_epoch [Integer] current time in ms since epoch
  # @param tz_offset [Integer] timezone offset in ms (0 in our tests)
  # @return [Integer] start time (ms) of the active occurrence
  def try_advance_active(millis_since_epoch, tz_offset)
    start_in_millis = (@start.to_r * 1000).to_i + tz_offset

    # No recurrence configured: always return schedule start.
    return set_current(@start, start_in_millis) if @freq.nil?

    now = Time.at(millis_since_epoch / 1000.0).utc

    if @current.nil?
      dates = occurrences_between(@start, now)
      unless dates.empty?
        @current = dates.last
        @upcoming = next_after(@current)
        return (@current.to_r * 1000).to_i
      end

      first_occ = first_occurrence
      if first_occ && (start_in_millis != (first_occ.to_r * 1000).to_i)
        @current = first_occ
        @upcoming = next_after(@current)
        return (@current.to_r * 1000).to_i
      end

      return set_current(@start, start_in_millis)
    end

    next_occ = next_after(now)
    if next_occ.nil?
      @current = @upcoming if @upcoming
      return (@current.to_r * 1000).to_i
    end

    if @upcoming && next_occ > @upcoming
      @current = @upcoming
    end
    @upcoming = next_occ

    (@current.to_r * 1000).to_i
  end

  # Ruby equivalent of Java's Schedule.getDelay.
  #
  # @param offset_seconds [Integer] offset from occurrence start, in seconds
  # @param time_since_occurrence_start_ms [Integer] ms since occurrence start
  # @param schedule [SimulatorSchedule, nil]
  # @return [Integer, nil] delay in ms, or nil if no further occurrences
  def self.get_delay(offset_seconds, time_since_occurrence_start_ms, schedule)
    offset_ms = offset_seconds * 1000
    if offset_ms <= time_since_occurrence_start_ms
      time_until = get_time_until_next_occurrence(time_since_occurrence_start_ms, schedule)
      return offset_ms - time_since_occurrence_start_ms if time_until.nil?
      return offset_ms + time_until
    end
    offset_ms - time_since_occurrence_start_ms
  end

  # Ruby equivalent of Java's Schedule.getTimeUntilNextOccurrence.
  def self.get_time_until_next_occurrence(time_since_occurrence_start_ms, schedule)
    if schedule
      if schedule.freq
        # Mirror Java's behaviour: use the actual duration between the
        # current and upcoming occurrences. Once there are no more future
        # occurrences, `upcoming` will equal `current`, so the duration
        # becomes zero and this returns a negative delay.
        return nil if schedule.current.nil? || schedule.upcoming.nil?
        duration_s = schedule.upcoming.to_i - schedule.current.to_i
        return duration_s * 1000 - time_since_occurrence_start_ms
      end
      return -time_since_occurrence_start_ms
    end

    DEFAULT_REPLAY_LOOP_DURATION - time_since_occurrence_start_ms
  end

  def is_after_schedule_end(millis)
    if @freq
      if @until_time
        return millis > (@until_time.to_r * 1000).to_i
      end
      return false
    end

    if @end_time
      return millis > (@end_time.to_r * 1000).to_i
    end

    false
  end

  private

  def set_current(time, millis)
    @current = time
    millis
  end

  def parse_recurrence(rrule)
    return @freq = nil unless rrule

    parts = rrule.split(";")
    opts = {}
    parts.each do |part|
      key, value = part.split("=", 2)
      opts[key] = value
    end

    @freq =
      case opts["FREQ"]
      when "DAILY" then :daily
      when "HOURLY" then :hourly
      when "MINUTELY" then :minutely
      else nil
      end

    @count = opts["COUNT"]&.to_i

    @until_time =
      if opts["UNTIL"]
        v = opts["UNTIL"]
        Time.utc(
          v[0, 4].to_i,
          v[4, 2].to_i,
          v[6, 2].to_i,
          v[9, 2].to_i,
          v[11, 2].to_i,
          v[13, 2].to_i
        )
      end

    @by_hour = opts["BYHOUR"]&.to_i
    @by_minute = opts["BYMINUTE"]&.to_i
  end

  def first_occurrence
    case @freq
    when :daily
      if @by_hour && @by_minute
        Time.utc(@start.year, @start.month, @start.day, @by_hour, @by_minute, 0)
      else
        @start
      end
    when :hourly, :minutely
      @start
    else
      nil
    end
  end

  def interval_seconds
    case @freq
    when :daily then 86_400
    when :hourly then 3_600
    when :minutely then 60
    else 0
    end
  end

  def occurrences_between(from_time, to_time)
    occs = []
    first = first_occurrence
    return occs unless first
    return occs if to_time < first

    step = interval_seconds
    return [ first ] if step.zero?

    n_max = ((to_time.to_i - first.to_i) / step).floor
    (0..n_max).each do |i|
      occ = first + i * step
      break if @count && i >= @count
      break if @until_time && occ > @until_time
      occs << occ
    end

    occs
  end

  def next_after(time)
    first = first_occurrence
    return nil unless first
    step = interval_seconds
    return nil if step.zero?

    # If we haven't reached the first occurrence yet
    return first if time < first

    elapsed = time.to_i - first.to_i
    n = (elapsed / step) + 1
    occ = first + n * step

    if @count && n >= @count
      return nil
    end
    if @until_time && occ > @until_time
      return nil
    end

    occ
  end
end
