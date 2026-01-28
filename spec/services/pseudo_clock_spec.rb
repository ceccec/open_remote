require "rails_helper"

RSpec.describe PseudoClock do
  it "uses UTC offset for unknown zone IDs" do
    clock = described_class.new
    date = Date.new(2024, 1, 1)
    time_of_day = Time.new(2024, 1, 1, 12, 0, 0, "+02:00")

    clock.set_time(date, time_of_day, "UNKNOWN_ZONE")

    # Equivalent to 2024-01-01 12:00:00 UTC in milliseconds
    expected = Time.new(2024, 1, 1, 12, 0, 0, "+00:00")
    expect(clock.current_time_millis).to eq((expected.to_r * 1000).to_i)
  end
end
