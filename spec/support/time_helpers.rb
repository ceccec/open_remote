##
# Time helper methods for RSpec tests.
#
# Adds convenience methods for working with timestamps at second-level precision.
module TimeHelpers
  # Add methods to ActiveSupport::TimeWithZone and Time
  ActiveSupport::TimeWithZone.class_eval do
    ##
    # Returns the beginning of the current second (microseconds set to 0).
    #
    # @return [ActiveSupport::TimeWithZone] time at the start of the current second
    def beginning_of_second
      change(usec: 0)
    end

    ##
    # Returns the end of the current second (microseconds set to 999999).
    #
    # @return [ActiveSupport::TimeWithZone] time at the end of the current second
    def end_of_second
      change(usec: 999999)
    end
  end

  Time.class_eval do
    ##
    # Returns the beginning of the current second (microseconds set to 0).
    #
    # @return [Time] time at the start of the current second
    def beginning_of_second
      change(usec: 0)
    end

    ##
    # Returns the end of the current second (microseconds set to 999999).
    #
    # @return [Time] time at the end of the current second
    def end_of_second
      change(usec: 999999)
    end
  end
end
