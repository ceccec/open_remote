# RuleManagerJob

# Recurring job to execute due rules periodically.

**Type:** Jobs  
**File:** `rule_manager_job.rb`
<Badge type="warning" text="File Coverage: 60.0%" />
<Badge type="info" text="3/17 lines" />


This job inherits from `ApplicationJob`, enabling asynchronous background processing. Jobs are enqueued and executed by Active Job adapters. See [ApplicationJob](https://api.rubyonrails.org/classes/ApplicationJob.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationJob](https://api.rubyonrails.org/classes/ApplicationJob.html) - Job enqueueing, callbacks, and execution
- **Queue Adapters**: [ActiveJob::QueueAdapters](https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters.html) - Background job processing adapters


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

- **Examples for this class**: 2
- **Test file**: `spec/jobs/rule_manager_job_spec.rb`
- **Last tested**: 2026-01-28 18:43:20

:::






## Methods

- `perform`
  <Badge type="warning" text="Coverage: 50.0%" />
  <small>Uncovered lines: 14</small>


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
