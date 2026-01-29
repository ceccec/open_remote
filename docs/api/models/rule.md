# Rule

# Declarative rule describing conditions (`when_config`) and actions (`then_config`)

**Type:** Models  
**File:** `rule.rb`
<Badge type="warning" text="File Coverage: 79.55%" />
<Badge type="info" text="35/133 lines" />


This model inherits from `ApplicationRecord`, providing database persistence, validations, associations, scopes, callbacks, query methods, and more. See [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations.html) - `has_many` relationships. See [ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for `has_many`, `belongs_to`, `has_one`
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks (`before_save`, `after_create`, etc.)
- **Scoping**: [ActiveRecord::Scoping](https://api.rubyonrails.org/classes/ActiveRecord/Scoping.html) - Named scopes and default scopes
- **Query Methods**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)
- **Querying**: [ActiveRecord::Querying](https://api.rubyonrails.org/classes/ActiveRecord/Querying.html) - Query interface and finder methods
- **Persistence**: [ActiveRecord::Persistence](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html) - `save`, `create`, `update`, `destroy` methods
- **ActiveRecord Module**: [ActiveRecord](https://api.rubyonrails.org/classes/ActiveRecord.html) - Complete API reference


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

- **Examples for this class**: 23
- **Test file**: `spec/models/rule_spec.rb`
- **Last tested**: 2026-01-28 17:06:46

:::



## Associations

ActiveRecord associations define relationships between models. See [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for details.

- `has_many :rule_executions` - one-to-many relationship - this model has many rule_executions


## Included Modules

These modules extend the class with additional behavior. Concerns use [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for modular functionality.

- `TestExpectations` - Provides additional functionality
- `Rule::Execution` - Provides additional functionality
- `Mapping::RuleJsonMapping` - Provides JSON import/export functionality
- `Rule::References` - Provides additional functionality
- `BatchActions` - Provides additional functionality



## Methods

- `execution_counts`
  <Badge type="tip" text="Coverage: 100.0%" />
- `has_failed_executions?`
  <Badge type="tip" text="Coverage: 100.0%" />
- `last_execution`
  <Badge type="tip" text="Coverage: 100.0%" />
- `last_successful_execution`
  <Badge type="tip" text="Coverage: 100.0%" />
- `scheduled?`
  <Badge type="tip" text="Coverage: 100.0%" />
- `then_config_presence`
  <Badge type="warning" text="Coverage: 66.67%" />
  <small>Uncovered lines: 130</small>
- `then_config_pretty_json`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - returns pretty JSON representations of configs
  - pretty prints empty configs as empty objects/arrays

- `when_config_presence`
  <Badge type="warning" text="Coverage: 66.67%" />
  <small>Uncovered lines: 119</small>
- `when_config_pretty_json`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - returns pretty JSON representations of configs
  - pretty prints empty configs as empty objects/arrays


## Examples

The following examples are extracted from test files:

### is valid with valid attributes

```ruby
      expect(rule).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:5`_


### is invalid without name

```ruby
      expect(rule).not_to be_valid
      expect(rule.errors[:name]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:17`_


### is invalid without when_config

```ruby
      expect(rule).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:26`_


### is invalid without then_config

```ruby
      expect(rule).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:31`_


### defaults enabled to true

```ruby
      expect(rule.enabled).to be_truthy
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:36`_


### defaults timezone to UTC

```ruby
      expect(rule.timezone).to eq("UTC")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:45`_


### adds validation errors when when_config is blank

```ruby
      expect(rule).not_to be_valid
      expect(rule.errors[:when_config]).to include("can't be blank")
      expect(rule.errors[:when_config]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:54`_


### adds validation errors when then_config is blank

```ruby
      expect(rule).not_to be_valid
      expect(rule.errors[:then_config]).to include("can't be blank")
      expect(rule.errors[:then_config]).to include("can't be blank")
      expect(rule.errors[:then_config]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:68`_


### returns pretty JSON representations of configs

```ruby
      expect(rule.when_config_pretty_json).to include("condition")
      expect(rule.then_config_pretty_json).to include("Log event")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:86`_


### pretty prints empty configs as empty objects/arrays

```ruby
      expect(JSON.parse(rule.when_config_pretty_json)).to eq({})
      expect(JSON.parse(rule.then_config_pretty_json)).to eq([])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:97`_


### has many rule_executions

```ruby
      expect(rule.rule_executions).to include(execution)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:110`_


### imports rule from OpenRemote JSON

```ruby
      expect(rule.name).to eq("Imported Rule")
      expect(rule.description).to eq("A test rule")
      expect(rule.enabled).to be_truthy
      expect(rule.when_config["condition"]).to eq("Schedule")
      expect(rule.then_config.first["action"]).to eq("Log event")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:126`_


### exports rule to OpenRemote JSON

```ruby
      expect(json["name"]).to eq("Test Rule")
      expect(json["description"]).to eq("A test")
      expect(json["enabled"]).to be_truthy
      expect(json["when"]["condition"]).to eq("Schedule")
      expect(json["then"].first["action"]).to eq("Log event")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:143`_


### executes scheduled rule

```ruby
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(execution.status).to eq("success")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:171`_


### skips disabled rule

```ruby
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(execution.status).to eq("skipped")
      expect(execution.result["reason"]).to eq("disabled")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:184`_


### executes attribute value rule when condition is met

```ruby
      expect { Rule.first.execute! }.to change { Notification.count }.by(1)
      expect(execution.status).to eq("success")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:198`_


### skips attribute value rule when condition is not met

```ruby
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(execution.status).to eq("skipped")
      expect(execution.result["reason"]).to eq("condition_not_met")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:218`_


### handles execution errors gracefully

```ruby
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(execution.status).to eq("skipped")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:239`_


### detects performance deviations between assets and sends notifications

```ruby
      expect { rule.execute! }.to change { Notification.count }.by(2)
      expect(notifications.map(&:asset)).to contain_exactly(high_output_asset, low_output_asset)
        expect(notification.severity).to eq("warning")
        expect(notification.message).to include(notification.asset.name)
        expect(notification.message).to include(notification.asset.attributes_data["location"])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:252`_


### supports different comparison operators in attribute value rules

```ruby
      expect { equal_rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(RuleExecution.last.status).to eq("success")
      expect { less_than_rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(RuleExecution.last.status).to eq("success")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:290`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/rule.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb`

---

[← Back to Index](/)
