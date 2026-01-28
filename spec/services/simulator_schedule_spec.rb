require "rails_helper"

RSpec.describe SimulatorSchedule do
  let(:start_time) { Time.utc(2024, 1, 1, 0, 0, 0) }

  describe ".get_time_until_next_occurrence" do
    it "returns default replay loop duration when schedule is nil" do
      delay = described_class.get_time_until_next_occurrence(1000, nil)
      expect(delay).to eq(SimulatorSchedule::DEFAULT_REPLAY_LOOP_DURATION - 1000)
    end
  end

  describe "#is_after_schedule_end" do
    it "returns false when there is no end_time and no recurrence" do
      schedule = described_class.new(start_time: start_time, end_time: nil, recurrence: nil)
      millis = (start_time.to_r * 1000).to_i + 10_000

      expect(schedule.is_after_schedule_end(millis)).to be(false)
    end

    it "returns true when fixed schedule end is passed" do
      end_time = start_time + 3600
      schedule = described_class.new(start_time: start_time, end_time: end_time, recurrence: nil)
      millis_after = ((end_time + 1).to_r * 1000).to_i

      expect(schedule.is_after_schedule_end(millis_after)).to be(true)
    end
  end
end
