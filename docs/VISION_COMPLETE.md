# YARD + RSpec + VitePress + SimpleCov: Complete Unified Documentation Vision

## The Complete Picture

A unified documentation system that combines:

1. **YARD**: Rich API documentation (method signatures, parameters, types, cross-references)
2. **RSpec**: Living examples (test-driven, always up-to-date, verified)
3. **VitePress**: Beautiful UI (modern, fast, searchable, responsive)
4. **SimpleCov**: Coverage metrics (line coverage, branch coverage, uncovered lines)

## Key Principles

### DRY (Don't Repeat Yourself)
- **No hardcoded documentation** - everything extracted from code
- **Single source of truth** - code is the documentation
- **Auto-generation** - docs update when code changes
- **Modular components** - reusable templates and generators

### Living Documentation
- Examples come from **passing tests** (RSpec)
- Coverage comes from **actual test execution** (SimpleCov)
- Structure comes from **code analysis** (AST parsing)
- UI comes from **VitePress components** (Vue)

## Complete Feature Set

### 1. Method Documentation

Each method automatically shows:

```markdown
### by_type

**Signature:** `def self.by_type(type_name: String) -> ActiveRecord::Relation`

<CoverageBadge :coverage="100" />

**Parameters:**
| Name | Type | Description | Default |
|------|------|-------------|---------|
| type_name | String | Asset type name | required |

**Returns:** `ActiveRecord::Relation<Asset>`

**Examples:**

```ruby
assets = Asset.by_type("sensor")
expect(assets).to include(sensor_asset)
```

<CoverageBadge :coverage="100" />
<Badge type="success" text="✓ Passing" />
<small>_Source: `spec/models/asset_spec.rb:45`_</small>

<MethodCoverage :coverage="{
  coverage_percentage: 100,
  covered_lines: [12, 13, 14],
  uncovered_lines: []
}" />
```

### 2. Coverage Visualization

- **Method-Level Coverage**: Each method shows its coverage percentage
- **Line Coverage**: Highlight covered/uncovered lines
- **Coverage Badges**: Color-coded indicators (green/yellow/red)
- **Uncovered Lines**: List of lines needing tests
- **Coverage Trends**: Track coverage over time

### 3. Class/Module Overview

- **Inheritance Chain**: Visual hierarchy
- **Included Modules**: Zeitwerk namespace structure
- **Method Count**: Total methods with coverage breakdown
- **Overall Coverage**: File-level coverage percentage
- **Test Statistics**: Examples count, passing/failing

### 4. Test-Driven Examples

- **Extracted Examples**: From RSpec `it` blocks
- **Coverage Mapping**: Which tests cover which lines
- **Example Coverage**: Each example shows coverage impact
- **Source Links**: Direct links to test files

## Architecture

### Data Flow

```
Code (Ruby) 
  ↓ [AST Parser]
Code Structure (methods, classes, associations)
  ↓
RSpec Tests
  ↓ [RSpec Parser]
Test Examples
  ↓
SimpleCov Results
  ↓ [Coverage Integration]
Coverage Metrics
  ↓
Template Generator (DRY)
  ↓
VitePress Markdown
  ↓ [VitePress Build]
Beautiful Documentation Site
```

### Components

1. **DocsCodeAnalyzer**: Parses Ruby AST to extract structure
2. **DocsRspecExtractor**: Extracts examples from RSpec tests
3. **DocsCoverageIntegration**: Reads SimpleCov coverage data
4. **DocsTemplateGenerator**: Generates markdown (DRY, no hardcoded content)
5. **VitePress Components**: Vue components for UI (CoverageBadge, MethodCoverage)

## Benefits

### For Developers
- **Always Accurate**: Documentation matches code exactly
- **Coverage Visibility**: See what's tested and what's not
- **Living Examples**: Examples are verified by tests
- **Easy Navigation**: Auto-generated structure

### For Documentation
- **No Maintenance**: Docs update automatically
- **Rich Context**: Method signatures, parameters, types
- **Visual Coverage**: See coverage at a glance
- **Searchable**: Full-text search across all docs

### For Testing
- **Coverage Gates**: Enforce 100% coverage requirement
- **Gap Identification**: See uncovered lines
- **Example Extraction**: Tests become documentation
- **Coverage Trends**: Track improvements

## Example Output

See:
- [`EXAMPLES/yard-rspec-vitepress-simplecov-example.md`](./EXAMPLES/yard-rspec-vitepress-simplecov-example.md) - Complete example
- [`api/models/asset_enhanced_example.md`](./api/models/asset_enhanced_example.md) - Enhanced styling example

## Implementation Status

✅ **RSpec Examples**: Extracted from tests  
✅ **VitePress UI**: Modern, searchable interface  
✅ **Zeitwerk Structure**: Auto-discovery sidebar  
✅ **SimpleCov Integration**: Coverage data extraction  
✅ **DRY Templates**: No hardcoded content  
🔄 **YARD Integration**: Method signature extraction (in progress)  
🔄 **Coverage Visualization**: Vue components (created, needs integration)

## Next Steps

1. Integrate SimpleCov data into documentation generation
2. Add coverage badges to generated docs
3. Create coverage visualization components
4. Extract method signatures from code/YARD
5. Build coverage trend tracking
