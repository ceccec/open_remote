# DataPoint

# Time-series measurement captured for a single `Asset`.

**Type:** Models  
**File:** `data_point.rb`

This model inherits from `ApplicationRecord`, providing database persistence, validations, associations, scopes, callbacks, query methods, and more. See [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations.html) - `belongs_to` relationships. See [ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for `has_many`, `belongs_to`, `has_one`
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

- **Examples for this class**: 12
- **Test file**: `spec/models/data_point_label_spec.rb`
- **Last tested**: 2026-01-28 23:47:32

:::



## Associations

ActiveRecord associations define relationships between models. See [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for details.

- `belongs_to :asset` - many-to-one relationship - this model belongs to a asset


## Included Modules

These modules extend the class with additional behavior. Concerns use [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for modular functionality.

- `TestExpectations` - Provides additional functionality
- `DataPoint::Analytics` - Adds querying and data access methods
- `DataPoint::BatchActions` - Provides additional functionality
- `DataPoint::References` - Provides additional functionality
- `BatchActions` - Provides additional functionality



## Methods

- `in_range?`
- `numeric_value`
- `older_than?`
- `rails_admin_label`


## Examples

The following examples are extracted from test files:

### includes asset name, attribute_name and formatted timestamp

```ruby
      expect(label).to include("Main Park")
      expect(label).to include("powerOutput")
      expect(label).to include("2026-01-28 15:45")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_label_spec.rb:22`_


### is valid with valid attributes

```ruby
      expect(data_point).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:14`_


### is invalid without attribute_name

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:24`_


### is invalid without value

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:33`_


### is invalid without timestamp

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:42`_


### belongs to asset

```ruby
      expect(data_point.asset).to eq(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:53`_


### calculates sum for time range

```ruby
      expect(sum).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:76`_


### calculates average for time range

```ruby
      expect(avg).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:88`_


### finds max value for time range

```ruby
      expect(max).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:100`_


### finds min value for time range

```ruby
      expect(min).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:112`_


### returns neutral values when there are no matching datapoints

```ruby
      expect(sum).to eq(0.0)
      expect(avg).to be_nil
      expect(max).to be_nil
      expect(min).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:124`_


### logs a warning instead of raising when continuous aggregate creation fails

```ruby
      expect(Rails.logger).to receive(:warn).with(
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:159`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/data_point.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_label_spec.rb`

---

[← Back to Index](/)
