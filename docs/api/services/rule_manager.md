# RuleManager

# Service for managing rule scheduling and periodic execution.

**Type:** Services  
**File:** `rule_manager.rb`
<Badge type="warning" text="File Coverage: 18.45%" />
<Badge type="info" text="19/347 lines" />



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

- **Examples for this class**: 38
- **Test file**: `spec/services/rule_manager_spec.rb`
- **Last tested**: 2026-01-29 03:27:01

:::






## Methods

- `cron_pattern?`
  <Badge type="warning" text="Coverage: 50.0%" />
  <small>Uncovered lines: 124</small>

  **Examples:**
  - returns true for valid 5-part cron expressions
  - returns false for non-cron strings

- `enqueue_rule_execution`
  <Badge type="tip" text="Coverage: 100.0%" />
- `execute_due_rules`
  <Badge type="warning" text="Coverage: 33.33%" />
  <small>Uncovered lines: 17, 18</small>
- `find_due_rules`
  <Badge type="warning" text="Coverage: 9.09%" />
  <small>Uncovered lines: 32, 33, 34, 35, 36...</small>
- `interval_pattern?`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - detects supported interval expressions
  - rejects unsupported strings

- `matches_cron_schedule`
  <Badge type="warning" text="Coverage: 4.17%" />
  <small>Uncovered lines: 282, 283, 284, 285, 286...</small>
- `matches_field`
  <Badge type="warning" text="Coverage: 5.26%" />
  <small>Uncovered lines: 315, 316, 317, 318, 319...</small>
- `matches_schedule?`
  <Badge type="warning" text="Coverage: 5.56%" />
  <small>Uncovered lines: 254, 255, 256, 257, 258...</small>
- `matches_time_schedule`
  <Badge type="warning" text="Coverage: 50.0%" />
  <small>Uncovered lines: 344</small>
- `next_execution_time`
  <Badge type="warning" text="Coverage: 12.5%" />
  <small>Uncovered lines: 63, 64, 65, 66, 67...</small>

  **Examples:**
  - returns nil for rules without schedule

- `parse_cron_schedule`
  <Badge type="warning" text="Coverage: 7.14%" />
  <small>Uncovered lines: 154, 155, 156, 157, 158...</small>
- `parse_interval_schedule`
  <Badge type="warning" text="Coverage: 4.55%" />
  <small>Uncovered lines: 195, 196, 197, 198, 199...</small>
- `parse_schedule`
  <Badge type="warning" text="Coverage: 5.26%" />
  <small>Uncovered lines: 97, 98, 99, 100, 101...</small>
- `parse_specific_time`
  <Badge type="warning" text="Coverage: 9.09%" />
  <small>Uncovered lines: 233, 234, 235, 236, 237...</small>
- `parse_time_schedule`
  <Badge type="warning" text="Coverage: 14.29%" />
  <small>Uncovered lines: 178, 179, 180, 181, 182...</small>
- `rule_due?`
  <Badge type="warning" text="Coverage: 25.0%" />
  <small>Uncovered lines: 51, 52, 53</small>

  **Examples:**
  - returns false for rules without schedule
  - returns true for rules with wildcard schedule

- `time_pattern?`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - detects HH:MM patterns
  - rejects invalid patterns


## Examples

The following examples are extracted from test files:

### returns enabled rules with schedule condition

```ruby
      expect(due_rules).to include(rule1)
      expect(due_rules).not_to include(rule2)
      expect(due_rules).not_to include(rule3)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:7`_


### returns false for rules without schedule

```ruby
      expect(RuleManager.rule_due?(rule)).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:52`_


### returns true for rules with wildcard schedule

```ruby
      expect(RuleManager.rule_due?(rule)).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:57`_


### returns nil for rules without schedule

```ruby
      expect(RuleManager.next_execution_time(rule)).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:74`_


### parses cron-like schedules

```ruby
      expect(next_time).to be_a(Time)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:79`_


### parses time schedules (HH:MM)

```ruby
      expect(next_time).to be_a(Time)
      expect(next_time.hour).to eq(17)
      expect(next_time.min).to eq(30)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:85`_


### parses interval schedules

```ruby
      expect(next_time).to be_a(Time)
      expect(next_time).to be > Time.current
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:93`_


### handles timezone correctly

```ruby
      expect(next_time.time_zone.name).to eq("America/New_York")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:100`_


### enqueues jobs for due rules

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:120`_


### returns count of enqueued rules

```ruby
      expect(count).to be >= 1
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:128`_


### enqueues a RuleExecutionJob

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:146`_


### returns true for valid 5-part cron expressions

```ruby
        expect(RuleManager.send(:cron_pattern?, "* * * * *")).to be true
        expect(RuleManager.send(:cron_pattern?, "0 5 * * 1-5")).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:158`_


### returns false for non-cron strings

```ruby
        expect(RuleManager.send(:cron_pattern?, "every 5 minutes")).to be false
        expect(RuleManager.send(:cron_pattern?, "17:30")).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:163`_


### detects HH:MM patterns

```ruby
        expect(RuleManager.send(:time_pattern?, "0:05")).to be true
        expect(RuleManager.send(:time_pattern?, "17:30")).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:170`_


### rejects invalid patterns

```ruby
        expect(RuleManager.send(:time_pattern?, "1730")).to be false
        expect(RuleManager.send(:time_pattern?, "every 5 minutes")).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:175`_


### detects supported interval expressions

```ruby
        expect(RuleManager.send(:interval_pattern?, "every 5 minutes")).to be true
        expect(RuleManager.send(:interval_pattern?, "every 1 hour")).to be true
        expect(RuleManager.send(:interval_pattern?, "every 2 days")).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:182`_


### rejects unsupported strings

```ruby
        expect(RuleManager.send(:interval_pattern?, "sometimes")).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:188`_


### schedules later today when time is in the future

```ruby
        expect(time.hour).to eq(13)
        expect(time.min).to eq(30)
        expect(time.to_date).to eq(base_time.to_date)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:194`_


### schedules for tomorrow when time has already passed today

```ruby
        expect(time.to_date).to eq((base_time + 1.day).to_date)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:201`_


### parses minute intervals

```ruby
        expect(time).to eq(base_time + 5.minutes)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:208`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/rule_manager.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb`

---

[← Back to Index](/)
