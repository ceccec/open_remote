# Asset

# Querying concern for Asset model.

**Type:** Models  
**File:** `asset/querying.rb`

This model inherits from `ApplicationRecord`, providing database persistence, validations, associations, scopes, callbacks, query methods, and more. See [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations.html) - `belongs_to`, `has_many` relationships. See [ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for `has_many`, `belongs_to`, `has_one`
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

- **Examples for this class**: 14
- **Test file**: `spec/models/asset_spec.rb`
- **Last tested**: 2026-01-28 16:55:22

:::






## Methods

- `of_type`

  **Examples:**
  - finds assets of specific type

- `solar_array_power_outputs`
- `solar_arrays`

  **Examples:**
  - finds solar arrays

- `solar_parks`

  **Examples:**
  - finds solar parks

- `with_numeric_attribute_greater_than`


## Examples

The following examples are extracted from test files:

### is valid with valid attributes

```ruby
      expect(asset).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:7`_


### is invalid without name

```ruby
      expect(asset).not_to be_valid
      expect(asset.errors[:name]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:16`_


### is invalid when attributes_data is nil

```ruby
      expect(asset).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:22`_


### belongs to asset_type

```ruby
      expect(asset.asset_type).to eq(asset_type)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:29`_


### belongs to parent asset

```ruby
      expect(child.parent).to eq(parent)
      expect(parent.children).to include(child)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:38`_


### has many data_points

```ruby
      expect(asset.data_points).to include(data_point)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:54`_


### imports asset from OpenRemote JSON

```ruby
      expect(asset.name).to eq("Imported Park")
      expect(asset.attributes_data["totalCapacity"]).to eq(5000)
      expect(asset.children.count).to eq(1)
      expect(asset.children.first.name).to eq("Array 1")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:71`_


### exports asset to OpenRemote JSON tree

```ruby
      expect(json["name"]).to eq("Parent Park")
      expect(json["type"]).to eq("SolarPark")
      expect(json["attributes"]["totalCapacity"]["value"]).to eq(5000)
      expect(json["children"].count).to eq(1)
      expect(json["children"].first["name"]).to eq("Child Array")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:100`_


### finds solar arrays

```ruby
      expect(Asset.solar_arrays).to include(array)
      expect(Asset.solar_arrays).not_to include(park)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:128`_


### finds solar parks

```ruby
      expect(Asset.solar_parks).to include(park)
      expect(Asset.solar_parks).not_to include(array)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:135`_


### finds assets of specific type

```ruby
      expect(Asset.of_type("SolarPark")).to include(park)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:142`_


### returns solar array power outputs as id and float pairs

```ruby
      expect(pairs.size).to eq(2)
      expect(pairs.map(&:last)).to contain_exactly(100.0, 200.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:147`_


### filters assets by numeric attribute greater than a threshold

```ruby
      expect(result).to include(high)
      expect(result).not_to include(low)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:166`_


### returns a pretty-printed JSON string of attributes_data

```ruby
      expect(json).to include("\"key\"")
      expect(json).to include("\"value\"")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb:186`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/asset/querying.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_spec.rb`

---

[← Back to Index](/)
