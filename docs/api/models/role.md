# Role

# Role model for Rolify.

**Type:** Models  
**File:** `role.rb`
<Badge type="warning" text="File Coverage: 73.68%" />
<Badge type="info" text="14/55 lines" />


This model inherits from `ApplicationRecord`, providing database persistence, validations, associations, callbacks, query methods, and more. See [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations.html) - `has_and_belongs_to_many`, `belongs_to` relationships. See [ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for `has_many`, `belongs_to`, `has_one`
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks (`before_save`, `after_create`, etc.)
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

- **Examples for this class**: 6
- **Test file**: `spec/models/role_spec.rb`
- **Last tested**: 2026-01-28 23:47:32

:::



## Associations

ActiveRecord associations define relationships between models. See [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for details.

- `has_and_belongs_to_many :users` - many-to-many relationship - this model has and belongs to many users
- `belongs_to :resource` - many-to-one relationship - this model belongs to a resource


## Included Modules

These modules extend the class with additional behavior. Concerns use [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for modular functionality.

- `TestExpectations` - Provides additional functionality



## Methods

- `find_or_create_by_name`
  <Badge type="tip" text="Coverage: 100.0%" />
- `rails_admin_label`
  <Badge type="warning" text="Coverage: 25.0%" />
  <small>Uncovered lines: 50, 51, 52</small>

  **Examples:**
  - returns just the name for global roles


## Examples

The following examples are extracted from test files:

### requires a name

```ruby
      expect(role).not_to be_valid
      expect(role.errors[:name]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:5`_


### enforces uniqueness of name scoped to resource

```ruby
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:11`_


### finds an existing global role

```ruby
      expect(found.id).to eq(existing.id)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:21`_


### creates a new global role when missing

```ruby
      expect do
      expect(role.resource).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:27`_


### returns just the name for global roles

```ruby
      expect(role.rails_admin_label).to eq("custom_admin")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:37`_


### includes resource_type and resource name when present

```ruby
      expect(label).to include("manager")
      expect(label).to include("Asset")
      expect(label).to include("Main Park")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:42`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/role.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb`

---

[← Back to Index](/)
