---
title: Asset.by_type - Complete YARD + RSpec + VitePress + SimpleCov Example
description: Example showing merged YARD documentation, RSpec examples, VitePress UI, and SimpleCov coverage
---

# Asset.by_type

<!-- MethodCard component example - commented out due to Vue parsing issues with nested quotes -->
<!--
<MethodCard :method="{
  name: 'by_type',
  visibility: 'public',
  test_status: 'passing',
  coverage: 100,
  signature: 'def self.by_type(type_name: String) -> ActiveRecord::Relation',
  description: 'Queries assets filtered by asset type name.',
  parameters: [
    { name: 'type_name', type: 'String', description: 'Asset type name', default: null }
  ],
  returns: {
    type: 'ActiveRecord::Relation<Asset>',
    description: 'Assets matching the type'
  },
  examples: [
    {
      title: 'Basic Usage',
      code: 'assets = Asset.by_type(\"sensor\")\nexpect(assets).to include(sensor_asset)',
      test_status: 'passing',
      coverage: 100,
      source_file: 'spec/models/asset_spec.rb:45'
    }
  ]
}" />
-->

<!-- MethodCoverage component example - commented out due to Vue parsing issues -->
<!--
<MethodCoverage :coverage="{
  coverage_percentage: 100,
  covered_lines: [12, 13, 14, 15],
  uncovered_lines: [],
  method_name: 'by_type',
  line_range: [12, 15]
}" />
-->

## Coverage Details

::: info SimpleCov Coverage

This method has **100% test coverage** with all lines executed by tests.

**Covered Lines:** 12, 13, 14, 15  
**Uncovered Lines:** None

:::

## Test Examples

All examples below are extracted from passing tests and verified by SimpleCov:

::: code-group

```ruby [Basic Usage - 100% Coverage]
# Line 12-15: Fully covered
assets = Asset.by_type("sensor")
expect(assets).to include(sensor_asset)
expect(assets.count).to eq(2)
```

<Badge type="tip" text="Coverage: 100%" />
<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:45`_</small>

```ruby [Chaining Queries - 100% Coverage]
# Line 12-18: Fully covered
active_sensors = Asset.by_type("sensor")
  .where(status: "active")
  .order(:name)
expect(active_sensors).to be_present
```

<Badge type="tip" text="Coverage: 100%" />
<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:52`_</small>

:::

## Coverage Visualization

### Line-by-Line Coverage

| Line | Code | Coverage | Tests |
|------|------|----------|-------|
| 12 | `def self.by_type(type_name)` | ✓ Covered | spec/models/asset_spec.rb:45 |
| 13 | `  AssetType.find_by(name: type_name)&.assets` | ✓ Covered | spec/models/asset_spec.rb:45, 52 |
| 14 | `end` | ✓ Covered | spec/models/asset_spec.rb:45, 52 |
| 15 | (blank) | ✓ Covered | - |

### Coverage Metrics

- **Method Coverage**: 100%
- **Branch Coverage**: 100%
- **Test Examples**: 2
- **Last Coverage Check**: 2026-01-29 14:30:00

## Related Methods Coverage

| Method | Coverage | Status |
|--------|----------|--------|
| `Asset.by_parent` | 95% | ⚠ Needs improvement |
| `AssetType.find_by_name` | 100% | ✓ Excellent |
| `Asset.where` | 100% | ✓ Excellent |

---

## SimpleCov Integration Benefits

1. **Visual Coverage Indicators**: See at a glance which methods are tested
2. **Uncovered Line Detection**: Identify gaps in test coverage
3. **Coverage Trends**: Track coverage improvements over time
4. **Coverage Gates**: Enforce 100% coverage requirement
5. **Interactive Coverage**: Click to see which tests cover which lines
