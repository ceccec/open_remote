# RuleManager Examples

Test-driven examples for RuleManager functionality.

### returns enabled rules with schedule condition

```ruby
      expect(due_rules).to include(rule1)
      expect(due_rules).not_to include(rule2)
      expect(due_rules).not_to include(rule3)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:7`_


---

### returns false for rules without schedule

```ruby
      expect(RuleManager.rule_due?(rule)).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:52`_


---

### returns true for rules with wildcard schedule

```ruby
      expect(RuleManager.rule_due?(rule)).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:57`_


---

### returns nil for rules without schedule

```ruby
      expect(RuleManager.next_execution_time(rule)).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:74`_


---

### parses cron-like schedules

```ruby
      expect(next_time).to be_a(Time)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:79`_


---

### parses time schedules (HH:MM)

```ruby
      expect(next_time).to be_a(Time)
      expect(next_time.hour).to eq(17)
      expect(next_time.min).to eq(30)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:85`_


---

### parses interval schedules

```ruby
      expect(next_time).to be_a(Time)
      expect(next_time).to be > Time.current
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:93`_


---

### handles timezone correctly

```ruby
      expect(next_time.time_zone.name).to eq("America/New_York")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:100`_


---

### enqueues jobs for due rules

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:120`_


---

### returns count of enqueued rules

```ruby
      expect(count).to be >= 1
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:128`_


---

### enqueues a RuleExecutionJob

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:146`_


---

### returns true for valid 5-part cron expressions

```ruby
        expect(RuleManager.send(:cron_pattern?, "* * * * *")).to be true
        expect(RuleManager.send(:cron_pattern?, "0 5 * * 1-5")).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:158`_


---

### returns false for non-cron strings

```ruby
        expect(RuleManager.send(:cron_pattern?, "every 5 minutes")).to be false
        expect(RuleManager.send(:cron_pattern?, "17:30")).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:163`_


---

### detects HH:MM patterns

```ruby
        expect(RuleManager.send(:time_pattern?, "0:05")).to be true
        expect(RuleManager.send(:time_pattern?, "17:30")).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:170`_


---

### rejects invalid patterns

```ruby
        expect(RuleManager.send(:time_pattern?, "1730")).to be false
        expect(RuleManager.send(:time_pattern?, "every 5 minutes")).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:175`_


---

### detects supported interval expressions

```ruby
        expect(RuleManager.send(:interval_pattern?, "every 5 minutes")).to be true
        expect(RuleManager.send(:interval_pattern?, "every 1 hour")).to be true
        expect(RuleManager.send(:interval_pattern?, "every 2 days")).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:182`_


---

### rejects unsupported strings

```ruby
        expect(RuleManager.send(:interval_pattern?, "sometimes")).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:188`_


---

### schedules later today when time is in the future

```ruby
        expect(time.hour).to eq(13)
        expect(time.min).to eq(30)
        expect(time.to_date).to eq(base_time.to_date)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:194`_


---

### schedules for tomorrow when time has already passed today

```ruby
        expect(time.to_date).to eq((base_time + 1.day).to_date)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:201`_


---

### parses minute intervals

```ruby
        expect(time).to eq(base_time + 5.minutes)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:208`_


---

### parses hour intervals

```ruby
        expect(time).to eq(base_time + 2.hours)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:213`_


---

### parses day intervals

```ruby
        expect(time).to eq(base_time + 3.days)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:218`_


---

### parses week intervals

```ruby
        expect(time).to eq(base_time + 2.weeks)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:223`_


---

### parses month intervals

```ruby
        expect(time).to eq(base_time + 1.month)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:228`_


---

### returns nil for invalid unit

```ruby
        expect(RuleManager.send(:parse_interval_schedule, "every 5 years", base_time, timezone)).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:233`_


---

### returns nil for invalid intervals

```ruby
        expect(RuleManager.send(:parse_interval_schedule, "every sometimes", base_time, timezone)).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:237`_


---

### handles wildcard schedule (* * * * *)

```ruby
        expect(time).to eq(base_time + 1.minute)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:243`_


---

### returns nil for invalid cron format

```ruby
        expect(RuleManager.send(:parse_cron_schedule, "invalid", base_time, timezone)).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:248`_


---

### handles complex patterns with default fallback

```ruby
        expect(time).to eq(base_time + 1.minute)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:254`_


---

### falls back to cron parsing for unrecognized patterns

```ruby
        expect(time).to be_a(Time).or be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:261`_


---

### matches cron patterns

```ruby
        expect(RuleManager.matches_schedule?("30 14 * * *", test_time, timezone)).to be true
        expect(RuleManager.matches_schedule?("0 14 * * *", test_time, timezone)).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:272`_


---

### matches time patterns

```ruby
        expect(RuleManager.matches_schedule?("14:30", test_time, timezone)).to be true
        expect(RuleManager.matches_schedule?("15:30", test_time, timezone)).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:277`_


---

### returns true for interval patterns

```ruby
        expect(RuleManager.matches_schedule?("every 5 minutes", test_time, timezone)).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:282`_


---

### falls back to cron matching for unrecognized patterns

```ruby
        expect(result).to be_in([ true, false ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:286`_


---

### matches wildcard

```ruby
        expect(RuleManager.send(:matches_field, "*", 10)).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:293`_


---

### matches exact value

```ruby
        expect(RuleManager.send(:matches_field, "5", 5)).to be true
        expect(RuleManager.send(:matches_field, "5", 6)).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:297`_


---

### matches ranges

```ruby
        expect(RuleManager.send(:matches_field, "0-5", 3)).to be true
        expect(RuleManager.send(:matches_field, "0-5", 6)).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:302`_


---

### matches lists

```ruby
        expect(RuleManager.send(:matches_field, "0,5,10", 5)).to be true
        expect(RuleManager.send(:matches_field, "0,5,10", 7)).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/rule_manager_spec.rb:307`_


---

[← Back to Index](/)
