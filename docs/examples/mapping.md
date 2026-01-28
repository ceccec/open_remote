# Mapping Examples

Test-driven examples for Mapping functionality.

### extracts values from OpenRemote format

```ruby
      expect(result["totalCapacity"]).to eq(5000)
      expect(result["status"]).to eq("active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:11`_


---

### handles already normalized attributes

```ruby
      expect(result["totalCapacity"]).to eq(5000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:21`_


---

### handles empty hash

```ruby
      expect(test_class.normalize_openremote_attributes({})).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:30`_


---

### handles nil

```ruby
      expect(test_class.normalize_openremote_attributes(nil)).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:34`_


---

### wraps values in OpenRemote format

```ruby
      expect(result["totalCapacity"]["value"]).to eq(5000)
      expect(result["status"]["value"]).to eq("active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:40`_


---

### handles empty hash

```ruby
      expect(test_class.denormalize_to_openremote_attributes({})).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:30`_


---

### handles nil

```ruby
      expect(test_class.denormalize_to_openremote_attributes(nil)).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/attribute_normalization_spec.rb:34`_


---

### exports asset to OpenRemote JSON format

```ruby
      expect(json["name"]).to eq("Parent")
      expect(json["type"]).to eq("SolarPark")
      expect(json["attributes"]["powerOutput"]).to eq({ "value" => 100.0 })
      expect(json["children"]).to be_an(Array)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb:22`_


---

### includes nested children in tree

```ruby
      expect(json["children"].length).to eq(1)
      expect(child_json["name"]).to eq("Child")
      expect(child_json["attributes"]["powerOutput"]).to eq({ "value" => 50.0 })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb:31`_


---

### denormalizes attributes to OpenRemote format

```ruby
      expect(json["attributes"]["powerOutput"]).to eq({ "value" => 100.0 })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb:43`_


---

### handles empty attributes_data

```ruby
      expect(json["attributes"]).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_export_spec.rb:49`_


---

### creates asset from OpenRemote JSON node

```ruby
      expect(asset).to be_persisted
      expect(asset.name).to eq("Test Asset")
      expect(asset.asset_type.name).to eq("SolarPark")
      expect(asset.attributes_data["powerOutput"]).to eq(100.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb:8`_


---

### creates nested children assets

```ruby
      expect(child).to be_persisted
      expect(child.name).to eq("Child")
      expect(child.parent).to eq(parent)
      expect(child.attributes_data["powerOutput"]).to eq(50.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb:25`_


---

### handles missing attributes gracefully

```ruby
      expect(asset.attributes_data).to eq({})
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb:48`_


---

### uses existing asset type if present

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/json_import_spec.rb:59`_


---

### creates rule from OpenRemote JSON node

```ruby
      expect(rule).to be_persisted
      expect(rule.name).to eq("Test Rule")
      expect(rule.description).to eq("Test Description")
      expect(rule.enabled).to be(true)
      expect(rule.when_config).to eq({ "schedule" => "FREQ=DAILY" })
      expect(rule.then_config).to eq([ { "action" => "log" } ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:5`_


---

### extracts schedule and timezone from when config

```ruby
      expect(rule.schedule).to eq("FREQ=HOURLY")
      expect(rule.timezone).to eq("America/New_York")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:24`_


---

### defaults enabled to true if not provided

```ruby
      expect(rule.enabled).to be(true)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:40`_


---

### defaults timezone to UTC if not provided

```ruby
      expect(rule.timezone).to eq("UTC")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:52`_


---

### updates existing rule if name matches

```ruby
      expect do
      expect(existing.when_config).to eq({ "new" => "data" })
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:64`_


---

### exports rule to OpenRemote JSON format

```ruby
      expect(json["name"]).to eq("Test Rule")
      expect(json["description"]).to eq("Test Description")
      expect(json["enabled"]).to be(true)
      expect(json["when"]).to eq({ "schedule" => "FREQ=DAILY" })
      expect(json["then"]).to eq([ { "action" => "log" } ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:97`_


---

### handles nil description

```ruby
      expect(json["description"]).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:107`_


---

### defaults empty configs to empty objects/arrays

```ruby
      expect(json["when"]).to eq({})
      expect(json["then"]).to eq([])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/mapping/rule_json_mapping_spec.rb:114`_


---

[← Back to Index](/)
