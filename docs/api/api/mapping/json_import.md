# Mapping::JsonImport

API documentation for Mapping::JsonImport

## Examples

The following examples are extracted from test files:

### creates asset from OpenRemote JSON node

```ruby
      expect(asset).to be_persisted
      expect(asset.name).to eq("Test Asset")
      expect(asset.asset_type.name).to eq("SolarPark")
      expect(asset.attributes_data["powerOutput"]).to eq(100.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb:8`_


### creates nested children assets

```ruby
      expect(child).to be_persisted
      expect(child.name).to eq("Child")
      expect(child.parent).to eq(parent)
      expect(child.attributes_data["powerOutput"]).to eq(50.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb:25`_


### handles missing attributes gracefully

```ruby
      expect(asset.attributes_data).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb:48`_


### uses existing asset type if present

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb:59`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb`

---

[← Back to Index](/)
