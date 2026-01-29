# Rule::Execution

# Runtime behavior for executing a `Rule` against the asset graph.

**Type:** Models  
**File:** `rule/execution.rb`
<Badge type="warning" text="File Coverage: 57.14%" />
<Badge type="info" text="76/396 lines" />


This model inherits from `ActiveRecord::Base`, providing database persistence, validations, associations, and callbacks. See [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) for the complete API.

**Rails Framework References:**
- **Base Class**: [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) - `has_many`, `belongs_to`, `has_one` relationships
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks
- **Query Interface**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)


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

:::






## Methods

- `apply_action!`
  <Badge type="warning" text="Coverage: 17.65%" />
  <small>Uncovered lines: 240, 241, 242, 243, 244...</small>
- `apply_asset_filters`
  <Badge type="warning" text="Coverage: 35.71%" />
  <small>Uncovered lines: 183, 184, 186, 187, 188...</small>
- `attribute_changed_condition?`
  <Badge type="tip" text="Coverage: 100.0%" />
- `attribute_value_condition?`
  <Badge type="tip" text="Coverage: 100.0%" />
- `build_asset_query`
  <Badge type="tip" text="Coverage: 100.0%" />
- `compare_assets_for_deviation`
  <Badge type="warning" text="Coverage: 3.23%" />
  <small>Uncovered lines: 327, 328, 329, 330, 331...</small>
- `compare_values`
  <Badge type="warning" text="Coverage: 30.77%" />
  <small>Uncovered lines: 206, 208, 210, 212, 213...</small>
- `condition_met?`
  <Badge type="warning" text="Coverage: 56.25%" />
  <small>Uncovered lines: 130, 133, 135, 136, 138...</small>
- `create_notifications_for_assets`
  <Badge type="warning" text="Coverage: 33.33%" />
  <small>Uncovered lines: 311, 312, 313, 314, 315...</small>
- `execute!`
  <Badge type="warning" text="Coverage: 35.71%" />
  <small>Uncovered lines: 27, 29, 32, 33, 34...</small>
- `handle_attribute_changed_rule`
  <Badge type="warning" text="Coverage: 20.0%" />
  <small>Uncovered lines: 113, 114, 115, 116</small>
- `handle_attribute_value_rule`
  <Badge type="warning" text="Coverage: 66.67%" />
  <small>Uncovered lines: 99, 103, 104</small>
- `handle_scheduled_rule`
  <Badge type="warning" text="Coverage: 11.11%" />
  <small>Uncovered lines: 81, 82, 83, 84, 85...</small>
- `interpolate_message`
  <Badge type="warning" text="Coverage: 30.77%" />
  <small>Uncovered lines: 369, 370, 372, 373, 375...</small>
- `log_event_action`
  <Badge type="warning" text="Coverage: 50.0%" />
  <small>Uncovered lines: 294</small>
- `log_execution`
  <Badge type="warning" text="Coverage: 40.0%" />
  <small>Uncovered lines: 391, 392, 393</small>
- `perform_actions!`
  <Badge type="tip" text="Coverage: 100.0%" />
- `schedule_condition?`
  <Badge type="tip" text="Coverage: 100.0%" />
- `send_notification_action`
  <Badge type="tip" text="Coverage: 100.0%" />
- `target_assets`
  <Badge type="tip" text="Coverage: 100.0%" />
- `update_attribute_action`
  <Badge type="warning" text="Coverage: 12.5%" />
  <small>Uncovered lines: 265, 266, 267, 268, 269...</small>
- `validated_target_assets`
  <Badge type="warning" text="Coverage: 75.0%" />
  <small>Uncovered lines: 72</small>




## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/rule/execution.rb`



---

[← Back to Index](/)
