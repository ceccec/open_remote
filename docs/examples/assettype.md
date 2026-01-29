# AssetType Examples

Test-driven examples for AssetType functionality.

### returns display_name when present

```ruby
      expect(subject.rails_admin_label).to eq("Pretty Name")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_label_spec.rb:12`_


---

### falls back to name when display_name is blank

```ruby
      expect(subject.rails_admin_label).to eq("internal_name")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_label_spec.rb:16`_


---

### is valid with valid attributes

```ruby
      expect(asset_type).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:5`_


---

### is invalid without name

```ruby
      expect(asset_type).not_to be_valid
      expect(asset_type.errors[:name]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:15`_


---

### is invalid with duplicate name

```ruby
      expect(asset_type).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:21`_


---

### has many assets

```ruby
      expect(asset_type.assets).to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:29`_


---

### destroys associated assets when destroyed

```ruby
      expect(Asset.find_by(id: asset.id)).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_spec.rb:39`_


---

[← Back to Index](/)
