# RuleExecutionJob

API documentation for RuleExecutionJob

**Type:** Jobs  
**File:** `rule_execution_job.rb`




## Methods

### `perform`



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
