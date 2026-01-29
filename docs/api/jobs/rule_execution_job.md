# RuleExecutionJob

# Job to execute a rule asynchronously.

**Type:** Jobs  
**File:** `rule_execution_job.rb`

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

- **Examples for this class**: 3
- **Test file**: `spec/jobs/rule_execution_job_spec.rb`
- **Last tested**: 2026-01-28 16:08:55

:::






## Methods

- `perform`

  **Examples:**
  - executes the rule
  - raises when rule is missing


## Examples

The following examples are extracted from test files:

### executes the rule

```ruby
      expect { RuleExecutionJob.perform_now(rule.id) }.to change { RuleExecution.count }.by(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_execution_job_spec.rb:14`_


### does not execute disabled rules

```ruby
      expect(execution.status).to eq("skipped")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_execution_job_spec.rb:18`_


### raises when rule is missing

```ruby
      expect { RuleExecutionJob.perform_now(99999) }.to raise_error(ActiveRecord::RecordNotFound)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_execution_job_spec.rb:25`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/jobs/rule_execution_job.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_execution_job_spec.rb`

---

[← Back to Index](/)
