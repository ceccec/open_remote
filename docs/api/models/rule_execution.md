# RuleExecution

API documentation for RuleExecution

**Type:** Models  
**File:** `rule_execution.rb`

## Associations

- `belongs_to :rule`




## Methods

- `_run_create_callbacks`
- `_run_destroy_callbacks`
- `_run_rollback_callbacks`
- `_run_save_callbacks`
- `_run_touch_callbacks`
- `_run_update_callbacks`
- `autosave_associated_records_for_rule`
- `autosave_associated_records_for_versions`
- `failed`
- `for_rule`
- `paper_trail_event`
- `paper_trail_event=`
- `paper_trail_options`
- `paper_trail_options=`
- `paper_trail_options?`
- `rails_admin_label`
- `recent`
- `skipped`
- `successful`
- `validate_associated_records_for_versions`
- `version`
- `version=`
- `version_association_name`
- `version_association_name=`
- `version_association_name?`
- `version_class_name`
- `version_class_name=`
- `version_class_name?`
- `versions_association_name`
- `versions_association_name=`
- `versions_association_name?`
- `with_errors`


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
