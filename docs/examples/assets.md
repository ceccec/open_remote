# Assets Examples

Test-driven examples for Assets functionality.

### returns only solar arrays

```ruby
      expect(arrays).to include(@array)
      expect(arrays).not_to include(@park)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:21`_


---

### returns only solar parks

```ruby
      expect(parks).to include(@park)
      expect(parks).not_to include(@array)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:29`_


---

### returns assets of specific type

```ruby
      expect(parks).to include(@park)
      expect(parks).not_to include(@array)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:37`_


---

### returns id and power output pairs for solar arrays

```ruby
      expect(pairs.size).to eq(2)
      expect(pairs.map(&:first)).to contain_exactly(@array.id.to_s, array2.id.to_s)
      expect(pairs.map(&:last)).to contain_exactly(1000.0, 2000.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:45`_


---

### returns empty array when no solar arrays exist

```ruby
      expect(pairs).to be_empty
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:59`_


---

### handles arrays without powerOutput attribute

```ruby
      expect(pair).to be_present
      expect(pair.last).to eq(0.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:66`_


---

### handles arrays with nil attributes_data

```ruby
      expect(pair).to be_present
      expect(pair.last).to eq(0.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:80`_


---

### handles string numeric powerOutput values

```ruby
      expect(pairs.map(&:last)).to include(1500.0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:95`_


---

### ensures id is always a string

```ruby
        expect(id_str).to be_a(String)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:106`_


---

### filters assets by numeric attribute value

```ruby
      expect(result).to include(high_capacity)
      expect(result).not_to include(low_capacity)
      expect(result).not_to include(@park)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:115`_


---

### handles string numeric values

```ruby
      expect(result).to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:134`_


---

### excludes assets without the attribute

```ruby
      expect(result).not_to include(asset_no_attr)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:145`_


---

### handles different attribute names

```ruby
      expect(result).to include(asset)
      expect(result).not_to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/assets/querying_spec.rb:156`_


---

### returns correct values from attributes_data

```ruby
      expect(asset.active_power).to eq(1000)
      expect(asset.reactive_power).to eq(500)
      expect(asset.apparent_power).to eq(1118)
      expect(asset.energy_import).to eq(5000)
      expect(asset.energy_export).to eq(2000)
      expect(asset.voltage).to eq(240)
      expect(asset.current).to eq(4.17)
      expect(asset.power_factor).to eq(0.9)
      expect(asset.frequency).to eq(60)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/energy_meter_attributes_spec.rb:39`_


---

### returns nil when attributes_data is empty

```ruby
      expect(asset.active_power).to be_nil
      expect(asset.voltage).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/energy_meter_attributes_spec.rb:51`_


---

### returns correct values

```ruby
      expect(asset.connection_capacity).to eq(10_000)
      expect(asset.active_power).to eq(8000)
      expect(asset.energy_exported).to eq(50_000)
      expect(asset.connection_status).to eq("connected")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/grid_connection_point_attributes_spec.rb:35`_


---

### returns correct values

```ruby
      expect(asset.inverter_capacity).to eq(5000)
      expect(asset.ac_power_output).to eq(4500)
      expect(asset.efficiency).to eq(0.9375)
      expect(asset.status).to eq("online")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/inverter_attributes_spec.rb:36`_


---

### returns nil when attribute is missing

```ruby
      expect(asset.inverter_capacity).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/inverter_attributes_spec.rb:43`_


---

### returns correct values

```ruby
      expect(asset.array_capacity).to eq(5000)
      expect(asset.power_output).to eq(4500)
      expect(asset.panel_count).to eq(20)
      expect(asset.status).to eq("online")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_array_attributes_spec.rb:36`_


---

### does nothing when total_capacity is zero

```ruby
      expect { asset.update_performance_ratio! }.not_to change { asset.attributes_data["performanceRatio"] }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:14`_


---

### does nothing when total_capacity is negative

```ruby
      expect { asset.update_performance_ratio! }.not_to change { asset.attributes_data["performanceRatio"] }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:19`_


---

### calculates and saves performance ratio when capacity is positive

```ruby
      expect(asset.attributes_data["performanceRatio"]).to eq(0.8)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:24`_


---

### initializes attributes_data if nil

```ruby
      expect(asset.attributes_data["performanceRatio"]).to eq(0.5)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/solar_park_attributes_spec.rb:31`_


---

### returns correct values

```ruby
      expect(asset.temperature).to eq(25.5)
      expect(asset.humidity).to eq(60)
      expect(asset.solar_irradiance).to eq(800)
      expect(asset.location).to eq("40.7128,-74.0060")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/concerns/assets/weather_station_attributes_spec.rb:35`_


---

[← Back to Index](/)
