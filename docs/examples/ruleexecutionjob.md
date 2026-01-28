# RuleExecutionJob Examples

Test-driven examples for RuleExecutionJob functionality.

### executes the rule

```ruby
      expect { RuleExecutionJob.perform_now(rule.id) }.to change { RuleExecution.count }.by(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_execution_job_spec.rb:14`_


---

### does not execute disabled rules

```ruby
      expect(execution.status).to eq("skipped")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_execution_job_spec.rb:18`_


---

### raises when rule is missing

```ruby
      expect { RuleExecutionJob.perform_now(99999) }.to raise_error(ActiveRecord::RecordNotFound)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/jobs/rule_execution_job_spec.rb:25`_


---

[← Back to Index](/)
