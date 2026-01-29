---
title: Asset - Enhanced YARD + RSpec + VitePress Example
description: Example showing merged YARD documentation, RSpec examples, and VitePress UI
---

# Asset

<Badge type="info" text="Model" />
<Badge type="success" text="100% Test Coverage" />
<Badge type="tip" text="14 Examples" />

**File:** <code>app/models/asset.rb</code>

::: tip Model Inheritance

This model inherits from `ApplicationRecord`, providing access to all base functionality including database persistence, validations, associations, scopes, callbacks, and query methods.

:::

::: info Rails Framework References

This component extends Rails framework functionality. Key references:

- **Base Class**: [ApplicationRecord](https://api.rubyonrails.org/classes/ApplicationRecord.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations.html) - `belongs_to`, `has_many` relationships
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Query Methods**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)

:::

## Class Methods

### `by_type(type_name)`

**Signature:** `def self.by_type(type_name: String) -> ActiveRecord::Relation<Asset>`

**Description:** Queries assets filtered by asset type name. Returns an ActiveRecord::Relation that can be further chained with other query methods.

**Parameters:**

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `type_name` | `String` | The name of the asset type to filter by (case-sensitive) | _required_ |

**Returns:** `ActiveRecord::Relation<Asset>` - A relation containing assets matching the specified type

**Examples:**

::: code-group

```ruby [Basic Usage]
# Find all assets of type "sensor"
assets = Asset.by_type("sensor")
expect(assets).to include(sensor_asset)
expect(assets.count).to eq(2)
```

<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:45`_</small>

```ruby [Chaining Queries]
# Chain with other query methods
active_sensors = Asset.by_type("sensor")
  .where(status: "active")
  .order(:name)
expect(active_sensors).to be_present
```

<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:52`_</small>

:::

**Related Methods:**
- [`Asset.by_parent`](#by_parent) - Filter by parent asset
- [`AssetType.find_by_name`](/api/models/asset_type#find_by_name) - Find asset type by name

---

### `solar_arrays`

**Signature:** `def self.solar_arrays -> ActiveRecord::Relation<Asset>`

**Description:** Returns all assets that are solar arrays.

**Returns:** `ActiveRecord::Relation<Asset>` - Collection of solar array assets

**Examples:**

```ruby
it "finds solar arrays" do
  arrays = Asset.solar_arrays
  expect(arrays).to include(solar_array_asset)
  expect(arrays.all? { |a| a.asset_type.name == "solar_array" }).to be true
end
```

<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:78`_</small>

---

## Instance Methods

### `update_performance_ratio!`

**Signature:** `def update_performance_ratio! -> Float`

**Description:** Calculates and updates the performance ratio for solar park assets based on current power output and capacity.

**Returns:** `Float` - The calculated performance ratio (0.0 to 1.0)

**Raises:** `ArgumentError` if asset is not a solar park

**Examples:**

```ruby
it "updates performance ratio for solar park" do
  solar_park.update_performance_ratio!
  expect(solar_park.performance_ratio).to be_between(0.0, 1.0)
end
```

<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/concerns/assets/solar_park_attributes_spec.rb:23`_</small>

---

## Associations

| Type | Name | Class | Description |
|------|------|-------|-------------|
| `belongs_to` | `asset_type` | `AssetType` | The type/category of this asset |
| `has_many` | `data_points` | `DataPoint` | Time-series data points for this asset |
| `has_many` | `notifications` | `Notification` | Notifications related to this asset |

## Validations

- **Presence:** `name` must be present
- **Uniqueness:** `name` must be unique within the same asset type
- **Format:** `name` must match required format

**Examples:**

```ruby
it "is valid with valid attributes" do
  asset = Asset.new(name: "Test Asset", asset_type: asset_type)
  expect(asset).to be_valid
end
```

<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:7`_</small>

```ruby
it "is invalid without name" do
  asset = Asset.new(asset_type: asset_type)
  expect(asset).not_to be_valid
  expect(asset.errors[:name]).to include("can't be blank")
end
```

<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:16`_</small>

---

## Included Modules

This model includes the following concerns:

- **`Assets::Querying`** - Query methods for filtering and searching assets
- **`Assets::SolarParkAttributes`** - Solar park-specific attributes and methods
- **`Mapping::JsonImport`** - Import assets from OpenRemote JSON format

**Zeitwerk Paths:**
- `app/models/asset/querying.rb` → `Assets::Querying`
- `app/models/concerns/assets/solar_park_attributes.rb` → `Assets::SolarParkAttributes`
- `app/models/concerns/mapping/json_import.rb` → `Mapping::JsonImport`

---

## Test Coverage

::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />

| Type | Count |
|------|-------|
| **Models** | 32 test files |
| **Other** | 13 test files |
| **Controllers** | 7 test files |
| **Services** | 7 test files |
| **Concerns** | 6 test files |
| **Jobs** | 3 test files |
| **Mailers** | 1 test file |

### Class-Specific Statistics

- **Examples for this class**: 14
- **Test file**: `spec/models/asset_spec.rb`
- **Last tested**: 2026-01-28 16:55:22
- **Coverage**: 100%

:::

---

## Source Code

**File:** `app/models/asset.rb`

**Related Files:**
- `app/models/asset/querying.rb` - Query methods
- `app/models/asset/references.rb` - Reference helpers
- `spec/models/asset_spec.rb` - Test suite

---

[← Back to Models Index](/api/models/)
