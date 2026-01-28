# AssetProcessingService Examples

Test-driven examples for AssetProcessingService functionality.

### updates the asset attribute

```ruby
      expect(asset.attributes_data["totalPowerOutput"]).to eq(800)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:14`_


---

### records a data point by default

```ruby
      expect do
      expect(datapoint.attribute_name).to eq("totalPowerOutput")
      expect(datapoint.value).to eq(800)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:21`_


---

### skips data point recording when option is false

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:31`_


---

### triggers attribute change rules by default

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:37`_


---

### processes multiple attribute updates

```ruby
      expect(asset.attributes_data["totalPowerOutput"]).to eq(800)
      expect(asset.attributes_data["efficiency"]).to eq(0.85)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:55`_


---

### finds assets with outdated attributes

```ruby
      expect(outdated["totalCapacity"]).to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:74`_


---

### does not include assets with recent data points

```ruby
        expect(outdated["totalCapacity"]).to be_nil
        expect(outdated["totalCapacity"]).not_to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:80`_


---

[← Back to Index](/)
