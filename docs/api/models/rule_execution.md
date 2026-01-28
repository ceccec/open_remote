# RuleExecution

API documentation for RuleExecution

**Type:** Models  
**File:** `rule_execution.rb`

## Associations

- `belongs_to :rule`




## Methods

- `rails_admin_label`


## Examples

The following examples are extracted from test files:

### is valid with valid attributes

```ruby
      expect(execution).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:13`_


### is invalid without executed_at

```ruby
      expect(execution).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:23`_


### is invalid without status

```ruby
      expect(execution).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:28`_


### belongs to rule

```ruby
      expect(execution.rule).to eq(rule)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:35`_


### includes rule name, status and formatted executed_at

```ruby
      expect(label).to include("Test Rule")
      expect(label).to include("failed")
      expect(label).to include("2026-01-28 14:30")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb:46`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/rule_execution.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb`

---

[← Back to Index](/)
