# RuleExecution

API documentation for RuleExecution

**Type:** Models  
**File:** `rule_execution.rb`

## Associations

- `belongs_to :rule`




## Methods

### `rails_admin_label`




### `version=`




### `autosave_associated_records_for_rule`




### `paper_trail_options?`




### `version_association_name?`




### `paper_trail_event=`




### `version_class_name?`




### `versions_association_name?`




### `_run_destroy_callbacks`




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




### `for_rule`




### `recent`




### `with_errors`




### `failed`




### `successful`




### `skipped`




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


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/rule_execution.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_spec.rb`

---

[← Back to Index](/)
