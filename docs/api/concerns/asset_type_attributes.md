# AssetTypeAttributes

API documentation for AssetTypeAttributes

This model inherits from `ActiveRecord::Base`, providing database persistence, validations, associations, and callbacks. See [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) for the complete API.

**Rails Framework References:**
- **Base Class**: [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - Database persistence, querying, and model lifecycle
- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) - `has_many`, `belongs_to`, `has_one` relationships
- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling
- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks
- **Query Interface**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)


## Examples

The following examples are extracted from test files:

### exposes energy meter attributes

```ruby
      expect(asset.active_power).to eq(1)
      expect(asset.reactive_power).to eq(2)
      expect(asset.apparent_power).to eq(3)
      expect(asset.energy_import).to eq(4)
      expect(asset.energy_export).to eq(5)
      expect(asset.voltage).to eq(6)
      expect(asset.current).to eq(7)
      expect(asset.power_factor).to eq(8)
      expect(asset.frequency).to eq(9)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:7`_


### exposes grid connection point attributes

```ruby
      expect(asset.connection_capacity).to eq(1)
      expect(asset.active_power).to eq(2)
      expect(asset.reactive_power).to eq(3)
      expect(asset.voltage).to eq(4)
      expect(asset.frequency).to eq(5)
      expect(asset.energy_exported).to eq(6)
      expect(asset.energy_imported).to eq(7)
      expect(asset.connection_status).to eq("connected")
      expect(asset.location).to eq("Point A")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:36`_


### exposes inverter attributes

```ruby
      expect(asset.inverter_capacity).to eq(1)
      expect(asset.ac_power_output).to eq(2)
      expect(asset.dc_power_input).to eq(3)
      expect(asset.ac_voltage).to eq(4)
      expect(asset.ac_frequency).to eq(5)
      expect(asset.efficiency).to eq(6)
      expect(asset.temperature).to eq(7)
      expect(asset.uptime).to eq(8)
      expect(asset.status).to eq("ok")
      expect(asset.alarm_status).to eq("none")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:65`_


### exposes solar array attributes

```ruby
      expect(asset.array_capacity).to eq(1)
      expect(asset.power_output).to eq(2)
      expect(asset.dc_voltage).to eq(3)
      expect(asset.dc_current).to eq(4)
      expect(asset.panel_count).to eq(5)
      expect(asset.panel_orientation).to eq("S")
      expect(asset.panel_tilt).to eq(30)
      expect(asset.temperature).to eq(6)
      expect(asset.status).to eq("ok")
      expect(asset.location).to eq("Field")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:96`_


### exposes solar park attributes including update_performance_ratio!

```ruby
      expect(asset.total_capacity).to eq(1000)
      expect(asset.total_power_output).to eq(500)
      expect(asset.total_energy_generated).to eq(2000)
      expect(asset.daily_energy_generated).to eq(100)
      expect(asset.forecasted_generation).to eq(2500)
      expect(asset.performance_ratio).to eq(40)
      expect(asset.location).to eq("Parkland")
      expect(asset.attributes_data["performanceRatio"]).to be_within(0.001).of(50.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:127`_


### exposes solar park attributes via Asset::Type::SolarParkAttributes duplication module

```ruby
      expect(asset.total_capacity).to eq(800)
      expect(asset.total_power_output).to eq(400)
      expect(asset.total_energy_generated).to eq(1600)
      expect(asset.daily_energy_generated).to eq(80)
      expect(asset.forecasted_generation).to eq(2000)
      expect(asset.performance_ratio).to eq(30)
      expect(asset.location).to eq("Duplicated")
      expect(asset.attributes_data["performanceRatio"]).to be_within(0.001).of(50.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:157`_


### exposes energy meter attributes via Assets::EnergyMeterAttributes

```ruby
      expect(asset.active_power).to eq(1)
      expect(asset.reactive_power).to eq(2)
      expect(asset.apparent_power).to eq(3)
      expect(asset.energy_import).to eq(4)
      expect(asset.energy_export).to eq(5)
      expect(asset.voltage).to eq(6)
      expect(asset.current).to eq(7)
      expect(asset.power_factor).to eq(8)
      expect(asset.frequency).to eq(9)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:188`_


### exposes grid connection point attributes via Assets::GridConnectionPointAttributes

```ruby
      expect(asset.connection_capacity).to eq(1)
      expect(asset.active_power).to eq(2)
      expect(asset.reactive_power).to eq(3)
      expect(asset.voltage).to eq(4)
      expect(asset.frequency).to eq(5)
      expect(asset.energy_exported).to eq(6)
      expect(asset.energy_imported).to eq(7)
      expect(asset.connection_status).to eq("connected")
      expect(asset.location).to eq("Point A")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:217`_


### exposes inverter attributes via Assets::InverterAttributes

```ruby
      expect(asset.inverter_capacity).to eq(1)
      expect(asset.ac_power_output).to eq(2)
      expect(asset.dc_power_input).to eq(3)
      expect(asset.ac_voltage).to eq(4)
      expect(asset.ac_frequency).to eq(5)
      expect(asset.efficiency).to eq(6)
      expect(asset.temperature).to eq(7)
      expect(asset.uptime).to eq(8)
      expect(asset.status).to eq("ok")
      expect(asset.alarm_status).to eq("none")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:246`_


### exposes solar array attributes via Assets::SolarArrayAttributes

```ruby
      expect(asset.array_capacity).to eq(1)
      expect(asset.power_output).to eq(2)
      expect(asset.dc_voltage).to eq(3)
      expect(asset.dc_current).to eq(4)
      expect(asset.panel_count).to eq(5)
      expect(asset.panel_orientation).to eq("S")
      expect(asset.panel_tilt).to eq(30)
      expect(asset.temperature).to eq(6)
      expect(asset.status).to eq("ok")
      expect(asset.location).to eq("Field")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:277`_


### exposes solar park attributes via Assets::SolarParkAttributes

```ruby
      expect(asset.total_capacity).to eq(1000)
      expect(asset.total_power_output).to eq(500)
      expect(asset.total_energy_generated).to eq(2000)
      expect(asset.daily_energy_generated).to eq(100)
      expect(asset.forecasted_generation).to eq(2500)
      expect(asset.performance_ratio).to eq(40)
      expect(asset.location).to eq("Parkland")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:308`_


### extends the correct module via Assets::TypeDispatch for all asset types



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:333`_


### reads weather station attributes from the concern

```ruby
      expect(asset.temperature).to eq(1)
      expect(asset.humidity).to eq(2)
      expect(asset.pressure).to eq(3)
      expect(asset.wind_speed).to eq(4)
      expect(asset.wind_direction).to eq(5)
      expect(asset.solar_irradiance).to eq(6)
      expect(asset.cloud_cover).to eq(7)
      expect(asset.visibility).to eq(8)
      expect(asset.location).to eq("Station")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb:384`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_type_attributes_spec.rb`

---

[← Back to Index](/)
