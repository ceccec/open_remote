---
title: Asset.by_type - YARD + RSpec + VitePress Example
description: Example of merged YARD documentation, RSpec examples, and VitePress UI
---

# Asset.by_type

<!-- MethodCard component - commented out due to Vue parsing issues -->
<!--
<MethodCard :method="{
  name: 'by_type',
  visibility: 'public',
  test_status: 'passing',
  signature: 'def self.by_type(type_name: String) -> ActiveRecord::Relation',
  description: 'Queries assets filtered by asset type name. Returns an ActiveRecord::Relation that can be further chained with other query methods.',
  parameters: [
    {
      name: 'type_name',
      type: 'String',
      description: 'The name of the asset type to filter by (case-sensitive)',
      default: null
    }
  ],
  returns: {
    type: 'ActiveRecord::Relation<Asset>',
    description: 'A relation containing assets matching the specified type'
  },
  examples: [
    {
      title: 'Basic Usage',
      code: 'assets = Asset.by_type(\"sensor\")\nexpect(assets).to include(sensor_asset)\nexpect(assets.count).to eq(2)',
      test_status: 'passing',
      source_file: 'spec/models/asset_spec.rb:45',
      source_link: 'https://github.com/ceccec/openremote/blob/main/spec/models/asset_spec.rb#L45'
    },
    {
      title: 'Chaining with Other Queries',
      code: 'active_sensors = Asset.by_type(\"sensor\")\n  .where(status: \"active\")\n  .order(:name)\nexpect(active_sensors).to be_present',
      test_status: 'passing',
      source_file: 'spec/models/asset_spec.rb:52',
      source_link: 'https://github.com/ceccec/openremote/blob/main/spec/models/asset_spec.rb#L52'
    }
  ],
  related_methods: [
    { name: 'Asset.by_parent', link: '/api/models/asset#by_parent' },
    { name: 'AssetType.find_by_name', link: '/api/models/asset_type#find_by_name' }
  ]
}" />
-->

## YARD Documentation

```ruby
# @!method self.by_type(type_name)
#   Query assets by asset type name
#   @param type_name [String] The name of the asset type
#   @return [ActiveRecord::Relation<Asset>] Assets matching the type
#   @example Find all sensors
#     Asset.by_type("sensor")
#   @example Chain with other queries
#     Asset.by_type("sensor").where(status: "active")
```

## RSpec Examples

All examples below are extracted from passing tests:

::: tip Test Coverage
This method has **2 passing examples** covering basic usage and query chaining.
:::

### Example 1: Basic Usage

```ruby
it "finds assets of specific type" do
  assets = Asset.by_type("sensor")
  expect(assets).to include(sensor_asset)
  expect(assets.count).to eq(2)
end
```

<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:45`_</small>

### Example 2: Chaining with Other Queries

```ruby
it "chains with other query methods" do
  active_sensors = Asset.by_type("sensor")
    .where(status: "active")
    .order(:name)
  expect(active_sensors).to be_present
end
```

<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:52`_</small>

## Related Documentation

- [Asset Model](/api/models/asset) - Complete Asset model documentation
- [AssetType Model](/api/models/asset_type) - Asset type definitions
- [ActiveRecord Querying](https://api.rubyonrails.org/classes/ActiveRecord/Querying.html) - Rails query interface

## Implementation Details

**File:** `app/models/asset/querying.rb:12`

**Included in:** `Asset` model via `Assets::Querying` concern

**Zeitwerk Path:** `app/models/asset/querying.rb` → `Assets::Querying`
