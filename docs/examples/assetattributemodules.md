# AssetAttributeModules Examples

Test-driven examples for AssetAttributeModules functionality.

### provides total_capacity accessor

```ruby
      expect(asset.total_capacity).to eq(1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:22`_


---

### provides total_power_output accessor

```ruby
      expect(asset.total_power_output).to eq(800)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:26`_


---

### provides total_energy_generated accessor

```ruby
      expect(asset.total_energy_generated).to eq(5000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:30`_


---

### provides daily_energy_generated accessor

```ruby
      expect(asset.daily_energy_generated).to eq(100)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:34`_


---

### provides forecasted_generation accessor

```ruby
      expect(asset.forecasted_generation).to eq(120)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:38`_


---

### provides performance_ratio accessor

```ruby
      expect(asset.performance_ratio).to eq(80.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:42`_


---

### provides location accessor

```ruby
      expect(asset.location).to eq("Test Location")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:46`_


---

### returns nil for missing attributes

```ruby
      expect(asset.total_capacity).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:50`_


---

### calculates and updates performance ratio when capacity is positive

```ruby
        expect(asset.performance_ratio).to eq(0.75)
        expect(asset.reload.attributes_data["performanceRatio"]).to eq(0.75)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:56`_


---

### does not update when capacity is zero

```ruby
        expect(asset.attributes_data["performanceRatio"]).to eq(original_ratio)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:67`_


---

### does not update when capacity is negative

```ruby
        expect(asset.attributes_data["performanceRatio"]).to eq(original_ratio)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:78`_


---

### does not update when capacity is nil

```ruby
        expect(asset.attributes_data["performanceRatio"]).to eq(original_ratio)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:89`_


---

### handles string numeric values

```ruby
        expect(asset.performance_ratio).to eq(0.8)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:99`_


---

### provides all attribute accessors

```ruby
      expect(asset.array_capacity).to eq(500)
      expect(asset.power_output).to eq(400)
      expect(asset.dc_voltage).to eq(600)
      expect(asset.dc_current).to eq(10)
      expect(asset.panel_count).to eq(100)
      expect(asset.panel_orientation).to eq("South")
      expect(asset.panel_tilt).to eq(30)
      expect(asset.temperature).to eq(25)
      expect(asset.status).to eq("active")
      expect(asset.location).to eq("Array Location")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:132`_


---

### provides all attribute accessors

```ruby
      expect(asset.inverter_capacity).to eq(100)
      expect(asset.ac_power_output).to eq(90)
      expect(asset.dc_power_input).to eq(95)
      expect(asset.ac_voltage).to eq(230)
      expect(asset.ac_frequency).to eq(50)
      expect(asset.efficiency).to eq(94.7)
      expect(asset.temperature).to eq(40)
      expect(asset.uptime).to eq(8760)
      expect(asset.status).to eq("operational")
      expect(asset.alarm_status).to eq("normal")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:132`_


---

### provides all attribute accessors

```ruby
      expect(asset.active_power).to eq(1000)
      expect(asset.reactive_power).to eq(200)
      expect(asset.apparent_power).to eq(1020)
      expect(asset.energy_import).to eq(5000)
      expect(asset.energy_export).to eq(3000)
      expect(asset.voltage).to eq(230)
      expect(asset.current).to eq(5)
      expect(asset.power_factor).to eq(0.98)
      expect(asset.frequency).to eq(50)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:132`_


---

### provides all attribute accessors

```ruby
      expect(asset.temperature).to eq(25.5)
      expect(asset.humidity).to eq(60)
      expect(asset.pressure).to eq(1013.25)
      expect(asset.wind_speed).to eq(10.5)
      expect(asset.wind_direction).to eq(180)
      expect(asset.solar_irradiance).to eq(800)
      expect(asset.cloud_cover).to eq(30)
      expect(asset.visibility).to eq(10)
      expect(asset.location).to eq("Station Location")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:132`_


---

### provides all attribute accessors

```ruby
      expect(asset.connection_capacity).to eq(1000)
      expect(asset.active_power).to eq(800)
      expect(asset.reactive_power).to eq(100)
      expect(asset.voltage).to eq(400)
      expect(asset.frequency).to eq(50)
      expect(asset.energy_exported).to eq(50000)
      expect(asset.energy_imported).to eq(30000)
      expect(asset.connection_status).to eq("connected")
      expect(asset.location).to eq("Grid Location")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/asset_attribute_modules_spec.rb:132`_


---

[← Back to Index](/)
