# AssetTypeDispatch

API documentation for AssetTypeDispatch

## Examples

The following examples are extracted from test files:

### extends SolarPark asset with Asset::Type::Solar::Park::Attributes

```ruby
      expect(asset).to respond_to(:total_capacity)
      expect(asset).to respond_to(:update_performance_ratio!)
      expect(asset.total_capacity).to eq(1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:5`_


### extends SolarArray asset with Asset::Type::Solar::Array::Attributes

```ruby
      expect(asset).to respond_to(:array_capacity)
      expect(asset.array_capacity).to eq(500)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:18`_


### extends Inverter asset with Asset::Type::Inverter::Attributes

```ruby
      expect(asset).to respond_to(:inverter_capacity)
      expect(asset.inverter_capacity).to eq(100)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:30`_


### extends EnergyMeter asset with Asset::Type::Energy::Meter::Attributes

```ruby
      expect(asset).to respond_to(:active_power)
      expect(asset.active_power).to eq(50)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:42`_


### extends WeatherStation asset with Asset::Type::Weather::Station::Attributes

```ruby
      expect(asset).to respond_to(:temperature)
      expect(asset.temperature).to eq(25)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:54`_


### extends GridConnectionPoint asset with Asset::Type::Grid::Connection::Point::Attributes

```ruby
      expect(asset).to respond_to(:connection_capacity)
      expect(asset.connection_capacity).to eq(1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:66`_


### does not extend when asset_type is nil

```ruby
      expect(asset).not_to respond_to(:total_capacity)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:78`_


### does not extend when asset_type name is unknown

```ruby
      expect(asset).not_to respond_to(:total_capacity)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:87`_


### extends module on after_find callback

```ruby
      expect(reloaded).to respond_to(:total_capacity)
      expect(reloaded.total_capacity).to eq(1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:98`_


### extends module on after_initialize callback

```ruby
      expect(asset).to respond_to(:total_capacity)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:112`_


### does not extend module if already extended

```ruby
      expect(asset).to respond_to(:total_capacity)
      expect(asset.method(:total_capacity)).to eq(original_method)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb:123`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_dispatch_spec.rb`

---

[← Back to Index](/)
