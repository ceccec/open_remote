# SimulatorSchedule Examples

Test-driven examples for SimulatorSchedule functionality.

### returns default replay loop duration when schedule is nil

```ruby
      expect(delay).to eq(SimulatorSchedule::DEFAULT_REPLAY_LOOP_DURATION - 1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:7`_


---

### returns false when there is no end_time and no recurrence

```ruby
      expect(schedule.is_after_schedule_end(millis)).to be(false)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:14`_


---

### returns true when fixed schedule end is passed

```ruby
      expect(schedule.is_after_schedule_end(millis_after)).to be(true)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:21`_


---

### returns true when until_time is passed for recurring schedule

```ruby
      expect(schedule.is_after_schedule_end(millis_after)).to be(true)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:29`_


---

### returns false when freq exists but no until_time

```ruby
      expect(schedule.is_after_schedule_end(millis)).to be(false)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:38`_


---

### returns negative delay when schedule has no freq

```ruby
      expect(delay).to eq(-5000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:47`_


---

### handles unknown FREQ value

```ruby
      expect(schedule.freq).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:54`_


---

### returns 0 for unknown frequency

```ruby
      expect(schedule.send(:interval_seconds)).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/simulator_schedule_spec.rb:61`_


---

[← Back to Index](/)
