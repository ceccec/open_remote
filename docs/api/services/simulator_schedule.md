# SimulatorSchedule

# Ruby port of the parts of OpenRemote's `SimulatorProtocol.Schedule` that are

**Type:** Services  
**File:** `simulator_schedule.rb`




## Methods

### `initialize`




### `try_advance_active`




### `get_delay`




### `get_time_until_next_occurrence`




### `is_after_schedule_end`



**Examples:**
- returns false when there is no end_time and no recurrence
- returns true when fixed schedule end is passed


### `set_current`




### `parse_recurrence`




### `first_occurrence`




### `interval_seconds`




### `occurrences_between`




### `next_after`




### `start`




### `freq`




### `by_hour`




### `by_minute`




### `until_time`




### `upcoming`




### `current`




### `end_time`




### `count`




## Examples

The following examples are extracted from test files:

### returns default replay loop duration when schedule is nil

```ruby
      expect(delay).to eq(SimulatorSchedule::DEFAULT_REPLAY_LOOP_DURATION - 1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:7`_


### returns false when there is no end_time and no recurrence

```ruby
      expect(schedule.is_after_schedule_end(millis)).to be(false)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:14`_


### returns true when fixed schedule end is passed

```ruby
      expect(schedule.is_after_schedule_end(millis_after)).to be(true)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:21`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/simulator_schedule.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb`

---

[← Back to Index](/)
