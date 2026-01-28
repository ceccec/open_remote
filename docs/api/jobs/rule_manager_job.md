# RuleManagerJob

# Recurring job to execute due rules periodically.

**Type:** Jobs  
**File:** `rule_manager_job.rb`




## Methods

### `perform`




## Examples

The following examples are extracted from test files:

### calls RuleManager.execute_due_rules

```ruby
      expect(RuleManager).to receive(:execute_due_rules).and_return(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_manager_job_spec.rb:16`_


### logs when rules are enqueued

```ruby
      expect(Rails.logger).to receive(:info).with("RuleManager: Enqueued 2 rule(s) for execution")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_manager_job_spec.rb:23`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/jobs/rule_manager_job.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_manager_job_spec.rb`

---

[← Back to Index](/)
