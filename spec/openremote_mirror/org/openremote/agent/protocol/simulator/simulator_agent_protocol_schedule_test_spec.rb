require "rails_helper"

RSpec.describe "SimulatorAgentProtocolSchedule",
               openremote_source_package: "org.openremote.agent.protocol.simulator" do
  it "shouldReturnStartAsCurrentForever",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#shouldReturnStartAsCurrentForever" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(start_time: start, end_time: nil, recurrence: nil)

    instants = [
      Time.utc(1999, 1, 1, 0, 0, 0),
      start,
      Time.utc(9999, 12, 31, 23, 59, 59)
    ]

    instants.each do |t|
      epoch = (t.to_r * 1000).to_i
      expect(schedule.try_advance_active(epoch, 0)).to eq((start.to_r * 1000).to_i)
    end
  end

  it "shouldAlwaysReturnStartAsCurrentWithEnd",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#shouldAlwaysReturnStartAsCurrentWithEnd" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    end_time = Time.utc(2000, 1, 10, 0, 0, 0)
    schedule = SimulatorSchedule.new(start_time: start, end_time: end_time, recurrence: nil)

    instants = [
      Time.utc(1999, 1, 1, 0, 0, 0),
      start,
      start + 1 * 86_400,
      start + 2 * 86_400,
      start + 3 * 86_400,
      start + 4 * 86_400,
      start + 5 * 86_400,
      start + 6 * 86_400,
      start + 7 * 86_400,
      start + 8 * 86_400,
      start + 9 * 86_400
    ]

    instants.each do |t|
      epoch = (t.to_r * 1000).to_i
      expect(schedule.try_advance_active(epoch, 0)).to eq((start.to_r * 1000).to_i)
    end

    # After end, schedule is considered finished but still returns start as in Java test
    end_epoch = (end_time.to_r * 1000).to_i
    expect(schedule.is_after_schedule_end(end_epoch + 1)).to be(true)
    expect(schedule.try_advance_active(end_epoch + 1, 0)).to eq((start.to_r * 1000).to_i)
  end

  it "shouldReturnOnlyCurrentAfterUntil",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#shouldReturnOnlyCurrentAfterUntil" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=DAILY;UNTIL=20000104T235959"
    )

    epoch_before = (Time.utc(1999, 1, 1, 0, 0, 0).to_r * 1000).to_i
    day = 86_400_000

    expect(schedule.try_advance_active(epoch_before + day - 1, 0)).to eq((start.to_r * 1000).to_i)

    instants = [
      start,
      start + 1 * 86_400,
      start + 2 * 86_400,
      start + 3 * 86_400
    ]

    instants.each do |t|
      epoch = (t.to_r * 1000).to_i
      expect(schedule.try_advance_active(epoch, 0)).to eq(epoch)
      expect(schedule.try_advance_active(epoch + day - 1, 0)).to eq(epoch)
    end

    until_start = Time.utc(2000, 1, 4, 0, 0, 0)
    until_epoch = (until_start.to_r * 1000).to_i
    expect(schedule.try_advance_active(until_epoch, 0)).to eq(until_epoch)
    expect(schedule.try_advance_active(until_epoch + day, 0)).to eq(until_epoch)
  end

  it "shouldReturnLastOccurrenceAfterCount",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#shouldReturnLastOccurrenceAfterCount" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=DAILY;COUNT=4"
    )

    epoch_before = (Time.utc(1999, 1, 1, 0, 0, 0).to_r * 1000).to_i
    day = 86_400_000

    expect(schedule.try_advance_active(epoch_before + day - 1, 0)).to eq((start.to_r * 1000).to_i)

    instants = [
      start,
      start + 1 * 86_400,
      start + 2 * 86_400
    ]

    instants.each do |t|
      epoch = (t.to_r * 1000).to_i
      expect(schedule.try_advance_active(epoch, 0)).to eq(epoch)
      expect(schedule.try_advance_active(epoch + day - 1, 0)).to eq(epoch)
    end

    last = Time.utc(2000, 1, 4, 0, 0, 0)
    last_epoch = (last.to_r * 1000).to_i
    expect(schedule.try_advance_active(last_epoch, 0)).to eq(last_epoch)
    expect(schedule.try_advance_active(last_epoch + day, 0)).to eq(last_epoch)
  end

  it "shouldStartAt1730",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#shouldStartAt1730" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=DAILY;BYHOUR=17;BYMINUTE=30"
    )

    day = 86_400_000
    epoch_before = (Time.utc(1999, 1, 1, 0, 0, 0).to_r * 1000).to_i
    expected = (start + 17 * 3600 + 30 * 60).to_i * 1000
    expect(schedule.try_advance_active(epoch_before + day - 1, 0)).to eq(expected)
  end

  it "shouldMinutelyReturnNextUntil",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#shouldMinutelyReturnNextUntil" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=MINUTELY;UNTIL=20000101T000500"
    )

    minute = 60_000
    epoch_before = (Time.utc(1999, 1, 1, 0, 0, 0).to_r * 1000).to_i
    expect(schedule.try_advance_active(epoch_before + minute - 1, 0)).to eq((start.to_r * 1000).to_i)

    instants = [
      start,
      start + 1 * 60,
      start + 2 * 60,
      start + 3 * 60
    ]

    instants.each do |t|
      epoch = (t.to_r * 1000).to_i
      expect(schedule.try_advance_active(epoch, 0)).to eq(epoch)
      expect(schedule.try_advance_active(epoch + minute - 1, 0)).to eq(epoch)
    end

    until_epoch = (Time.utc(2000, 1, 1, 0, 4, 0).to_r * 1000).to_i
    expect(schedule.try_advance_active(until_epoch + minute, 0)).to eq(until_epoch)
    expect(schedule.try_advance_active(until_epoch + 2 * minute, 0)).to eq(until_epoch)
  end

  it "shouldCatchUpWithCurrentTime",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#shouldCatchUpWithCurrentTime" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=MINUTELY"
    )

    minute = 60_000
    epoch = (Time.utc(2000, 1, 1, 1, 0, 0).to_r * 1000).to_i
    expect(schedule.try_advance_active(epoch, 0)).to eq((start + 60 * 60).to_i * 1000)
    expect(schedule.try_advance_active(epoch + minute, 0)).to eq((start + 61 * 60).to_i * 1000)
  end

  it "getDelayForHourlyRecurrence",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#getDelayForHourlyRecurrence" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=HOURLY"
    )

    now = (start.to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(100_000)

    now = (Time.utc(2000, 1, 1, 0, 1, 39).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(1_000)

    now = (Time.utc(2000, 1, 1, 0, 1, 40).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(3_600_000)
  end

  it "getDelayForHourlyRecurrenceWithStartDate",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#getDelayForHourlyRecurrenceWithStartDate" do
    start = Time.utc(2000, 1, 2, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=HOURLY"
    )

    now = (Time.utc(2000, 1, 1, 0, 0, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(86_400_000 + 100_000)

    now = (Time.utc(2000, 1, 1, 0, 1, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(86_400_000 + 40_000)

    now = (Time.utc(2000, 1, 1, 0, 2, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(86_400_000 - 20_000)
  end

  it "getDelayCustomRecurringWithUntil",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#getDelayCustomRecurringWithUntil" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=HOURLY;UNTIL=20000101T020000"
    )

    second = 1_000

    now = (Time.utc(2000, 1, 1, 0, 0, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(100 * second)

    now = (Time.utc(2000, 1, 1, 0, 1, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(40 * second)

    now = (Time.utc(2000, 1, 1, 0, 2, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(3_580 * second)

    now = (Time.utc(2000, 1, 1, 1, 0, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(100 * second)

    now = (Time.utc(2000, 1, 1, 1, 1, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(40 * second)

    now = (Time.utc(2000, 1, 1, 1, 2, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(3_580 * second)

    now = (Time.utc(2000, 1, 1, 2, 0, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(100 * second)

    now = (Time.utc(2000, 1, 1, 2, 1, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(40 * second)

    # After 3rd occurrence, delays become negative
    now = (Time.utc(2000, 1, 1, 2, 2, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(-20 * second)

    now = (Time.utc(2000, 1, 1, 3, 0, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(-3_500 * second)
  end

  it "getDelayCustomRecurringWithCount",
     openremote_source: "org.openremote.agent.protocol.simulator.SimulatorAgentProtocolScheduleTest#getDelayCustomRecurringWithCount" do
    start = Time.utc(2000, 1, 1, 0, 0, 0)
    schedule = SimulatorSchedule.new(
      start_time: start,
      end_time: nil,
      recurrence: "FREQ=HOURLY;COUNT=3"
    )

    second = 1_000

    now = (Time.utc(2000, 1, 1, 0, 0, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(100 * second)

    now = (Time.utc(2000, 1, 1, 0, 1, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(40 * second)

    now = (Time.utc(2000, 1, 1, 0, 2, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(3_580 * second)

    now = (Time.utc(2000, 1, 1, 1, 0, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(100 * second)

    now = (Time.utc(2000, 1, 1, 1, 1, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(40 * second)

    # After 3rd occurrence, delays become negative
    now = (Time.utc(2000, 1, 1, 2, 2, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(-20 * second)

    now = (Time.utc(2000, 1, 1, 3, 0, 0).to_r * 1000).to_i
    time_since = now - schedule.try_advance_active(now, 0)
    expect(SimulatorSchedule.get_delay(100, time_since, schedule)).to eq(-3_500 * second)
  end
end
