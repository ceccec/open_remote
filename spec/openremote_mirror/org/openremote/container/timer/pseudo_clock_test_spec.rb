require "rails_helper"

RSpec.describe "PseudoClock",
               openremote_source_package: "org.openremote.container.timer" do
  it "testSetTime",
     openremote_source: "org.openremote.container.timer.PseudoClockTest#testSetTime" do
    clock = PseudoClock.new

    clock.set_time(Date.new(1970, 1, 1), Time.new(1970, 1, 1, 0, 0, 0, "+00:00"), "UTC")
    expect(clock.current_time_millis).to eq(0)

    clock.set_time(Date.new(1970, 1, 2), Time.new(1970, 1, 1, 0, 0, 0, "+00:00"), "UTC")
    expect(clock.current_time_millis).to eq(24 * 3_600_000)

    clock.set_time(Date.new(1970, 1, 1), Time.new(1970, 1, 1, 0, 0, 0, "+01:00"), "CET")
    expect(clock.current_time_millis).to eq(-3_600_000)

    clock.set_time(Date.new(1970, 1, 2), Time.new(1970, 1, 1, 0, 0, 0, "+01:00"), "CET")
    expect(clock.current_time_millis).to eq(23 * 3_600_000)
  end

  it "testSetTimeISO",
     openremote_source: "org.openremote.container.timer.PseudoClockTest#testSetTimeISO" do
    clock = PseudoClock.new

    clock.set_time_iso("1970-01-01T00:00:00.000Z")
    expect(clock.current_time_millis).to eq(0)

    clock.set_time_iso("1970-01-02T00:00:00.000Z")
    expect(clock.current_time_millis).to eq(24 * 3_600_000)

    clock.set_time_iso("1970-01-01T00:00:00.000+01:00")
    expect(clock.current_time_millis).to eq(-3_600_000)

    clock.set_time_iso("1970-01-02T00:00:00.000+01:00")
    expect(clock.current_time_millis).to eq(23 * 3_600_000)
  end
end
