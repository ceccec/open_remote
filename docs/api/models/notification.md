# Notification

API documentation for Notification

**Type:** Models  
**File:** `notification.rb`

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

- **Examples for this class**: 10
- **Test file**: `spec/models/notification_spec.rb`
- **Last tested**: 2026-01-28 22:43:06

:::



## Associations

ActiveRecord associations define relationships between models. See [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for details.

- `belongs_to :asset` - many-to-one relationship - this model belongs to a asset
- `belongs_to :rule` - many-to-one relationship - this model belongs to a rule


## Included Modules

These modules extend the class with additional behavior. Concerns use [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for modular functionality.

- `TestExpectations` - Provides additional functionality
- `BatchActions` - Provides additional functionality



## Methods

- `acknowledge!`
- `acknowledged?`
- `rails_admin_label`
- `severity?`


## Examples

The following examples are extracted from test files:

### is valid with valid attributes

```ruby
      expect(notification).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:21`_


### is invalid without message

```ruby
      expect(notification).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:32`_


### is invalid without severity

```ruby
      expect(notification).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:40`_


### is invalid without sent_at

```ruby
      expect(notification).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:48`_


### can exist without asset

```ruby
      expect(notification).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:56`_


### can exist without rule

```ruby
      expect(notification).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:66`_


### belongs to asset optionally

```ruby
      expect(notification.asset).to eq(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:78`_


### belongs to rule optionally

```ruby
      expect(notification.rule).to eq(rule)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:88`_


### includes message and severity and associated names when present

```ruby
      expect(label).to include("warning")
      expect(label).to include(asset.name)
      expect(label).to include(rule.name)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:100`_


### only includes available parts

```ruby
      expect(label).to eq("Short message - (error)")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:115`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/notification.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb`

---

[← Back to Index](/)
