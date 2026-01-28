# AssetDatapointService

# Service for managing asset data points.

**Type:** Services  
**File:** `asset_datapoint_service.rb`




## Methods

### `record_datapoint`




### `record_datapoints`




### `get_datapoints`




### `get_latest_datapoint`




### `get_latest_datapoints`




### `cleanup_old_datapoints`




### `record_current_attributes`



**Examples:**
- returns empty array for asset without attributes


### `record_all_attributes_for_type`




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


### records data points for all current attributes

```ruby
      expect do
      expect(datapoint.attribute_name).to eq("totalCapacity")
      expect(datapoint.value).to eq(1000)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:81`_


### returns empty array for asset without attributes

```ruby
      expect(AssetDatapointService.record_current_attributes(asset)).to eq([])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:91`_


### deletes data points older than threshold

```ruby
      expect do
      expect(DataPoint.where("timestamp < ?", 90.days.ago).count).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb:105`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/asset_datapoint_service.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_datapoint_service_spec.rb`

---

[← Back to Index](/)
