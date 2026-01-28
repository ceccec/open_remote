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

[← Back to Index](/)
