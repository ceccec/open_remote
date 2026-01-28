# Rule

# Declarative rule describing conditions (`when_config`) and actions (`then_config`)

**Type:** Models  
**File:** `rule.rb`

## Associations

- `has_many :rule_executions`


## Included Modules

- `Rule::Execution`
- `Mapping::RuleJsonMapping`



## Methods

### `when_config_pretty_json`



**Examples:**
- returns pretty JSON representations of configs
- pretty prints empty configs as empty objects/arrays


### `then_config_pretty_json`



**Examples:**
- returns pretty JSON representations of configs
- pretty prints empty configs as empty objects/arrays


### `when_config_presence`




### `then_config_presence`




### `version=`




### `autosave_associated_records_for_rule_executions`




### `validate_associated_records_for_rule_executions`




### `paper_trail_options?`




### `version_association_name?`




### `paper_trail_event=`




### `version_class_name?`




### `_run_destroy_callbacks`




### `versions_association_name?`




### `_run_save_callbacks`




### `_run_create_callbacks`




### `_run_update_callbacks`




### `autosave_associated_records_for_versions`




### `paper_trail_options`




### `validate_associated_records_for_versions`




### `version`




### `version_class_name`




### `version_class_name=`




### `_run_rollback_callbacks`




### `versions_association_name=`




### `_run_touch_callbacks`




### `version_association_name`




### `versions_association_name`




### `version_association_name=`




### `paper_trail_event`




### `paper_trail_options=`




### `disabled`



**Examples:**
- skips disabled rule


### `recently_executed`




### `with_schedule`




### `attribute_value`




### `scheduled`




### `enabled`



**Examples:**
- defaults enabled to true
- imports rule from OpenRemote JSON
- exports rule to OpenRemote JSON


### `with_failed_executions`




### `attribute_changed`




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


### executes attribute changed rules without condition checks

```ruby
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(RuleExecution.last.status).to eq("success")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:326`_


### logs informational actions without raising for forecast/grid strategy actions

```ruby
      expect(Rails.logger).to receive(:info).twice
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(RuleExecution.last.status).to eq("success")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:343`_


### logs a failed execution and re-raises when an error occurs

```ruby
      expect do
        expect { rule.execute! }.to raise_error(StandardError, "boom")
      expect(execution.status).to eq("failed")
      expect(execution.result["error"]).to eq("boom")
      expect(execution.result["backtrace"]).to be_an(Array)
      expect(execution.result["backtrace"].length).to be <= 5
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb:360`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/rule.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_spec.rb`

---

[← Back to Index](/)
