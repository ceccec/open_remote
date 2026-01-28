# RuleExecution Examples

Test-driven examples for RuleExecution functionality.

### is valid with valid attributes

```ruby
      expect(execution).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:13`_


---

### is invalid without executed_at

```ruby
      expect(execution).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:23`_


---

### is invalid without status

```ruby
      expect(execution).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:28`_


---

### belongs to rule

```ruby
      expect(execution.rule).to eq(rule)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:35`_


---

[← Back to Index](/)
