# AssetProcessingService

# Service for processing asset attributes and triggering related actions.

**Type:** Services  
**File:** `asset_processing_service.rb`
<Badge type="warning" text="File Coverage: 20.0%" />
<Badge type="info" text="6/124 lines" />



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

- **Examples for this class**: 7
- **Test file**: `spec/services/asset_processing_service_spec.rb`
- **Last tested**: 2026-01-29 03:29:54

:::






## Methods

- `process_attribute_update`
  <Badge type="warning" text="Coverage: 5.56%" />
  <small>Uncovered lines: 25, 26, 27, 28, 29...</small>
- `process_attribute_updates`
  <Badge type="warning" text="Coverage: 20.0%" />
  <small>Uncovered lines: 53, 54, 55, 56</small>
- `process_outdated_attributes`
  <Badge type="warning" text="Coverage: 5.0%" />
  <small>Uncovered lines: 103, 104, 105, 106, 107...</small>
- `rule_should_trigger?`
  <Badge type="warning" text="Coverage: 33.33%" />
  <small>Uncovered lines: 90, 91</small>
- `trigger_attribute_change_rules`
  <Badge type="warning" text="Coverage: 9.09%" />
  <small>Uncovered lines: 68, 69, 70, 71, 72...</small>


## Examples

The following examples are extracted from test files:

### updates the asset attribute

```ruby
      expect(asset.attributes_data["totalPowerOutput"]).to eq(800)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:14`_


### records a data point by default

```ruby
      expect do
      expect(datapoint.attribute_name).to eq("totalPowerOutput")
      expect(datapoint.value).to eq(800)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:21`_


### skips data point recording when option is false

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:31`_


### triggers attribute change rules by default

```ruby
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:37`_


### processes multiple attribute updates

```ruby
      expect(asset.attributes_data["totalPowerOutput"]).to eq(800)
      expect(asset.attributes_data["efficiency"]).to eq(0.85)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:55`_


### finds assets with outdated attributes

```ruby
      expect(outdated["totalCapacity"]).to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:74`_


### does not include assets with recent data points

```ruby
        expect(outdated["totalCapacity"]).to be_nil
        expect(outdated["totalCapacity"]).not_to include(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb:80`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/asset_processing_service.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/asset_processing_service_spec.rb`

---

[← Back to Index](/)
