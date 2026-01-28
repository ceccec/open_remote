# Assets::SolarParkAttributes

API documentation for Assets::SolarParkAttributes

## Examples

The following examples are extracted from test files:

### does nothing when total_capacity is zero

```ruby
      expect { asset.update_performance_ratio! }.not_to change { asset.attributes_data["performanceRatio"] }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:14`_


### does nothing when total_capacity is negative

```ruby
      expect { asset.update_performance_ratio! }.not_to change { asset.attributes_data["performanceRatio"] }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:19`_


### calculates and saves performance ratio when capacity is positive

```ruby
      expect(asset.attributes_data["performanceRatio"]).to eq(80.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:24`_


### initializes attributes_data if nil

```ruby
      expect(asset.attributes_data["performanceRatio"]).to eq(50.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:31`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb`

---

[← Back to Index](/)
