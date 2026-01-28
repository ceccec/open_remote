##
# Minimal Ruby port of OpenRemote's `LockByKey` utility.
# Provides a per-key mutex so callers can coordinate access to shared
# resources identified by a String key.
class LockByKey
  ##
  # Internal wrapper for a per-key mutex.
  class LockWrapper
    attr_reader :mutex

    def initialize
      @mutex = Mutex.new
    end

    def lock
      @mutex.lock
    end

    def unlock
      @mutex.unlock
    end
  end

  def initialize
    @locks = {}
    @locks_mutex = Mutex.new
  end

  ##
  # Acquire the lock associated with the given key, blocking if another
  # thread already holds it.
  #
  # @param key [String] logical lock key
  # @return [void]
  def lock(key)
    wrapper = nil
    @locks_mutex.synchronize do
      wrapper = (@locks[key] ||= LockWrapper.new)
    end
    wrapper.lock
  end

  ##
  # Release the lock associated with the given key.
  #
  # @param key [String] logical lock key
  # @return [void]
  def unlock(key)
    wrapper = nil
    @locks_mutex.synchronize do
      wrapper = @locks[key]
    end
    wrapper&.unlock
  end
end
