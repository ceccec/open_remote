# SimulatorSchedule

# Ruby port of the parts of OpenRemote's `SimulatorProtocol.Schedule` that are

**Type:** Services  
**File:** `simulator_schedule.rb`




## Methods

- `first_occurrence`
- `get_delay`
- `get_time_until_next_occurrence`
- `initialize`
- `interval_seconds`

  **Examples:**
  - returns 0 for unknown frequency

- `is_after_schedule_end`

  **Examples:**
  - returns false when there is no end_time and no recurrence
  - returns true when fixed schedule end is passed
  - returns true when until_time is passed for recurring schedule
  - returns false when freq exists but no until_time

- `next_after`
- `occurrences_between`
- `parse_recurrence`
- `set_current`
- `try_advance_active`


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


### returns true when until_time is passed for recurring schedule

```ruby
      expect(schedule.is_after_schedule_end(millis_after)).to be(true)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:29`_


### returns false when freq exists but no until_time

```ruby
      expect(schedule.is_after_schedule_end(millis)).to be(false)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:38`_


### returns negative delay when schedule has no freq

```ruby
      expect(delay).to eq(-5000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:47`_


### handles unknown FREQ value

```ruby
      expect(schedule.freq).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:54`_


### returns 0 for unknown frequency

```ruby
      expect(schedule.send(:interval_seconds)).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:61`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/simulator_schedule.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb`

---

[← Back to Index](/)
