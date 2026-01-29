# DataPoint::BatchActions

# Batch actions specific to DataPoint model.

**Type:** Models  
**File:** `data_point/batch_actions.rb`

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

### Class-Specific Statistics

- **Examples for this class**: 14
- **Test file**: `spec/models/data_point/batch_actions_spec.rb`
- **Last tested**: 2026-01-29 00:23:13

:::






## Methods

- `batch_aggregate_by_window`
- `batch_cleanup_for_asset`

  **Examples:**
  - deletes old data points for a specific asset
  - works with asset ID

- `batch_cleanup_for_attribute`

  **Examples:**
  - deletes old data points for a specific attribute

- `batch_cleanup_older_than`

  **Examples:**
  - deletes data points older than the given timestamp
  - does not delete recent data points
  - returns the number of records deleted

- `batch_delete_duplicates`

  **Examples:**
  - deletes duplicate data points, keeping the most recent

- `batch_transform_values`
- `extract_numeric_value`


## Examples

The following examples are extracted from test files:

### deletes data points older than the given timestamp

```ruby
      expect { DataPoint.batch_cleanup_older_than(1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:11`_


### does not delete recent data points

```ruby
      expect { DataPoint.batch_cleanup_older_than(1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:17`_


### returns the number of records deleted

```ruby
      expect(DataPoint.batch_cleanup_older_than(1.month.ago)).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:22`_


### handles large batches



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:26`_


### deletes old data points for a specific asset

```ruby
      expect { DataPoint.batch_cleanup_for_asset(asset, 1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:45`_


### works with asset ID

```ruby
      expect { DataPoint.batch_cleanup_for_asset(asset.id, 1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:51`_


### deletes old data points for a specific attribute

```ruby
      expect { DataPoint.batch_cleanup_for_attribute("power", 1.month.ago) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:60`_


### transforms values using a block



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:68`_


### handles errors gracefully

```ruby
      expect(results[:failed]).to eq(1)
      expect(results[:errors].first[:error]).to eq("Test error")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:78`_


### deletes duplicate data points, keeping the most recent

```ruby
      expect { DataPoint.batch_delete_duplicates }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:92`_


### keeps the data point with the highest ID

```ruby
      expect(remaining.count).to eq(1)
      expect(remaining.first.id).to eq([ duplicate1.id, duplicate2.id, duplicate3.id ].max)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:97`_


### creates aggregated data points by time window

```ruby
      expect(results[:created]).to be > 0
      expect(aggregated.count).to be > 0
      expect(aggregated.first.value["aggregated"]).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:110`_


### calculates average correctly

```ruby
      expect(aggregated.value["value"]).to be_within(0.01).of(200.0) # (100 + 200) / 2
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:119`_


### supports sum aggregation

```ruby
      expect(aggregated.value["value"]).to eq(300.0) # 100 + 200
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb:125`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/data_point/batch_actions.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point/batch_actions_spec.rb`

---

[← Back to Index](/)
