require "rails_helper"

RSpec.describe LockByKey do
  describe "#lock and #unlock" do
    it "provides per-key mutex functionality" do
      lock_by_key = LockByKey.new
      key = "test_key"

      # Should not raise
      lock_by_key.lock(key)
      lock_by_key.unlock(key)
    end

    it "allows different keys to be locked independently" do
      lock_by_key = LockByKey.new

      lock_by_key.lock("key1")
      lock_by_key.lock("key2")
      lock_by_key.unlock("key1")
      lock_by_key.unlock("key2")
    end

    it "handles unlock on non-existent key gracefully" do
      lock_by_key = LockByKey.new

      expect { lock_by_key.unlock("nonexistent") }.not_to raise_error
    end
  end

  describe "thread safety" do
    it "ensures mutual exclusion for same key" do
      lock_by_key = LockByKey.new
      key = "shared_key"
      counter = 0
      mutex = Mutex.new

      threads = 5.times.map do
        Thread.new do
          lock_by_key.lock(key)
          mutex.synchronize { counter += 1 }
          sleep 0.01
          mutex.synchronize { counter -= 1 }
          lock_by_key.unlock(key)
        end
      end

      threads.each(&:join)

      expect(counter).to eq(0)
    end
  end
end
