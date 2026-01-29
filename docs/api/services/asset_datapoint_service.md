# AssetDatapointService

# Service for managing asset data points.

**Type:** Services  
**File:** `asset_datapoint_service.rb`


::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 11
- **Test file**: `spec/services/asset_datapoint_service_spec.rb`
- **Last tested**: 2026-01-28 22:43:06

:::






## Methods

- `cleanup_old_datapoints`
- `get_datapoints`
- `get_latest_datapoint`
- `get_latest_datapoints`
- `record_all_attributes_for_type`
- `record_current_attributes`

  **Examples:**
  - returns empty array for asset without attributes

- `record_datapoint`
- `record_datapoints`


## Examples

The following examples are extracted from test files:

### creates a data point for an asset attribute

```ruby
      expect do
      expect(datapoint.asset).to eq(asset)
      expect(datapoint.attribute_name).to eq("totalCapacity")
      expect(datapoint.value).to eq(1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:14`_


### uses provided timestamp

```ruby
      expect(datapoint.timestamp).to be_within(1.second).of(timestamp)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:25`_


### creates multiple data points

```ruby
      expect do
      expect(DataPoint.where(asset: asset, attribute_name: "totalCapacity").count).to eq(1)
      expect(DataPoint.where(asset: asset, attribute_name: "totalPowerOutput").count).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:34`_


### returns data points within time range

```ruby
      expect(datapoints.count).to eq(1)
      expect(datapoints.first.value).to eq(1100)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:56`_


### returns the most recent data point

```ruby
      expect(latest.value).to eq(1200)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:73`_


### returns a hash of latest datapoints by attribute name

```ruby
      expect(latest.keys).to contain_exactly("totalCapacity", "totalPowerOutput")
      expect(latest["totalCapacity"].value).to eq(1200)
      expect(latest["totalPowerOutput"].value).to eq(800)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:87`_


### records data points for all current attributes

```ruby
      expect do
      expect(datapoint.attribute_name).to eq("totalCapacity")
      expect(datapoint.value).to eq(1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:97`_


### returns empty array for asset without attributes

```ruby
      expect(AssetDatapointService.record_current_attributes(asset)).to eq([])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:107`_


### deletes data points older than threshold

```ruby
      expect do
      expect(DataPoint.where("timestamp < ?", 90.days.ago).count).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:121`_


### returns 0 when asset type does not exist

```ruby
      expect(count).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:131`_


### records datapoints for all assets of given type

```ruby
      expect do
        expect(count).to eq(2) # two attributes for one asset
      expect(DataPoint.where(asset: other_asset).count).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:136`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/asset_datapoint_service.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb`

---

[← Back to Index](/)
