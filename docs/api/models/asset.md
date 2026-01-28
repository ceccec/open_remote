# Asset

API documentation for Asset

**Type:** Models  
**File:** `asset/querying.rb`




## Methods

- `_run_create_callbacks`
- `_run_destroy_callbacks`
- `_run_find_callbacks`
- `_run_initialize_callbacks`
- `_run_rollback_callbacks`
- `_run_save_callbacks`
- `_run_touch_callbacks`
- `_run_update_callbacks`
- `attributes_data_pretty_json`
- `autosave_associated_records_for_asset_type`
- `autosave_associated_records_for_children`
- `autosave_associated_records_for_data_points`
- `autosave_associated_records_for_notifications`
- `autosave_associated_records_for_parent`
- `autosave_associated_records_for_versions`
- `by_type`
- `of_type`

  **Examples:**
  - finds assets of specific type

- `paper_trail_event`
- `paper_trail_event=`
- `paper_trail_options`
- `paper_trail_options=`
- `paper_trail_options?`
- `root_assets`
- `solar_array_power_outputs`
- `solar_arrays`

  **Examples:**
  - finds solar arrays

- `solar_parks`

  **Examples:**
  - finds solar parks

- `validate_associated_records_for_children`
- `validate_associated_records_for_data_points`
- `validate_associated_records_for_notifications`
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
- `with_numeric_attribute_greater_than`
- `with_parent`


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
