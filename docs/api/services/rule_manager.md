# RuleManager

# Service for managing rule scheduling and periodic execution.

**Type:** Services  
**File:** `rule_manager.rb`


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
- **Last tested**: 2026-01-28 23:47:32

:::






## Methods

- `cron_pattern?`

  **Examples:**
  - returns true for valid 5-part cron expressions
  - returns false for non-cron strings

- `enqueue_rule_execution`
- `execute_due_rules`
- `find_due_rules`
- `interval_pattern?`

  **Examples:**
  - detects supported interval expressions
  - rejects unsupported strings

- `matches_cron_schedule`
- `matches_field`
- `matches_schedule?`
- `matches_time_schedule`
- `next_execution_time`

  **Examples:**
  - returns nil for rules without schedule

- `parse_cron_schedule`
- `parse_interval_schedule`
- `parse_schedule`
- `parse_specific_time`
- `parse_time_schedule`
- `rule_due?`

  **Examples:**
  - returns false for rules without schedule
  - returns true for rules with wildcard schedule

- `time_pattern?`

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
