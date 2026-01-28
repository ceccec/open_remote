# AssetType

API documentation for AssetType

**Type:** Models  
**File:** `asset_type.rb`

## Associations

- `has_many :assets`




## Methods

### `rails_admin_label`




### `version=`




### `paper_trail_options?`




### `version_association_name?`




### `paper_trail_event=`




### `version_class_name?`




### `_run_destroy_callbacks`




### `versions_association_name?`




### `_run_save_callbacks`




### `_run_create_callbacks`




### `_run_update_callbacks`




### `autosave_associated_records_for_versions`




### `paper_trail_options`




### `validate_associated_records_for_versions`




### `version`




### `version_class_name`




### `autosave_associated_records_for_assets`




### `validate_associated_records_for_assets`




### `versions_association_name=`




### `version_class_name=`




### `_run_rollback_callbacks`




### `_run_touch_callbacks`




### `version_association_name`




### `versions_association_name`




### `version_association_name=`




### `paper_trail_event`




### `paper_trail_options=`




### `by_name`




### `with_assets`




## Examples

The following examples are extracted from test files:

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

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb`

---

[← Back to Index](/)
