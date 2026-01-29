# SimulatorSchedule

# Ruby port of the parts of OpenRemote's `SimulatorProtocol.Schedule` that are

**Type:** Services  
**File:** `simulator_schedule.rb`
<Badge type="warning" text="File Coverage: 12.71%" />
<Badge type="info" text="15/227 lines" />



::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 8
- **Test file**: `spec/services/simulator_schedule_spec.rb`
- **Last tested**: 2026-01-28 22:58:35

:::






## Methods

- `first_occurrence`
  <Badge type="warning" text="Coverage: 8.33%" />
  <small>Uncovered lines: 162, 163, 164, 165, 166...</small>
- `get_delay`
  <Badge type="warning" text="Coverage: 14.29%" />
  <small>Uncovered lines: 75, 76, 77, 78, 79...</small>
- `get_time_until_next_occurrence`
  <Badge type="warning" text="Coverage: 7.14%" />
  <small>Uncovered lines: 86, 87, 88, 89, 90...</small>
- `initialize`
  <Badge type="warning" text="Coverage: 20.0%" />
  <small>Uncovered lines: 16, 17, 18, 19</small>
- `interval_seconds`
  <Badge type="warning" text="Coverage: 16.67%" />
  <small>Uncovered lines: 177, 178, 179, 180, 181</small>

  **Examples:**
  - returns 0 for unknown frequency

- `is_after_schedule_end`
  <Badge type="warning" text="Coverage: 8.33%" />
  <small>Uncovered lines: 103, 104, 105, 106, 107...</small>

  **Examples:**
  - returns false when there is no end_time and no recurrence
  - returns true when fixed schedule end is passed
  - returns true when until_time is passed for recurring schedule
  - returns false when freq exists but no until_time

- `next_after`
  <Badge type="warning" text="Coverage: 5.0%" />
  <small>Uncovered lines: 206, 207, 208, 209, 210...</small>
- `occurrences_between`
  <Badge type="warning" text="Coverage: 5.88%" />
  <small>Uncovered lines: 186, 187, 188, 189, 190...</small>
- `parse_recurrence`
  <Badge type="warning" text="Coverage: 2.94%" />
  <small>Uncovered lines: 125, 126, 127, 128, 129...</small>
- `set_current`
  <Badge type="warning" text="Coverage: 50.0%" />
  <small>Uncovered lines: 120</small>
- `try_advance_active`
  <Badge type="warning" text="Coverage: 2.7%" />
  <small>Uncovered lines: 29, 30, 31, 32, 33...</small>


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
