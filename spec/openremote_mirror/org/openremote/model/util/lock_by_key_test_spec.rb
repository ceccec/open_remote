require "rails_helper"

RSpec.describe "LockByKey",
               openremote_source_package: "org.openremote.model.util" do
  it "testThreadStarvation (no starvation for queued threads)",
     openremote_source: "org.openremote.model.util.LockByKeyTest#testThreadStarvation" do
    lock_by_key = LockByKey.new
    key = "testKey"

    executed = []

    first = Thread.new do
      lock_by_key.lock(key)
      executed << :first_enter
      sleep 0.1
      executed << :first_exit
      lock_by_key.unlock(key)
    end

    second = Thread.new do
      lock_by_key.lock(key)
      executed << :second_enter
      lock_by_key.unlock(key)
      executed << :second_exit
    end

    first.join(1)
    second.join(1)

    expect(executed).to include(:first_enter, :first_exit, :second_enter, :second_exit)
    first_enter_index = executed.index(:first_enter)
    first_exit_index = executed.index(:first_exit)
    second_enter_index = executed.index(:second_enter)

    # Second thread must enter the critical section only after first exited it.
    expect(first_enter_index).to be < first_exit_index
    expect(first_exit_index).to be < second_enter_index
  end
end
