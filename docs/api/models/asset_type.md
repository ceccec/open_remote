# AssetType

# Represents a category or type of asset in the system.

**Type:** Models  
**File:** `asset_type.rb`
<Badge type="warning" text="File Coverage: 82.35%" />
<Badge type="info" text="14/55 lines" />


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

- **Examples for this class**: 7
- **Test file**: `spec/models/asset_type_label_spec.rb`
- **Last tested**: 2026-01-28 23:47:32

:::



## Associations

ActiveRecord associations define relationships between models. See [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for details.

- `has_many :assets` - one-to-many relationship - this model has many assets


## Included Modules

These modules extend the class with additional behavior. Concerns use [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for modular functionality.

- `TestExpectations` - Provides additional functionality



## Methods

- `assets_count`
  <Badge type="tip" text="Coverage: 100.0%" />
- `has_assets?`
  <Badge type="tip" text="Coverage: 100.0%" />
- `rails_admin_label`
  <Badge type="tip" text="Coverage: 100.0%" />

  **Examples:**
  - returns display_name when present
  - falls back to name when display_name is blank


## Examples

The following examples are extracted from test files:

### returns display_name when present

```ruby
      expect(subject.rails_admin_label).to eq("Pretty Name")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_label_spec.rb:12`_


### falls back to name when display_name is blank

```ruby
      expect(subject.rails_admin_label).to eq("internal_name")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_label_spec.rb:16`_


### is valid with valid attributes

```ruby
      expect(asset_type).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:5`_


### is invalid without name

```ruby
      expect(asset_type).not_to be_valid
      expect(asset_type.errors[:name]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:15`_


### is invalid with duplicate name

```ruby
      expect(asset_type).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:21`_


### has many assets

```ruby
      expect(asset_type.assets).to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:29`_


### destroys associated assets when destroyed

```ruby
      expect(Asset.find_by(id: asset.id)).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:39`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/asset_type.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_label_spec.rb`

---

[← Back to Index](/)
