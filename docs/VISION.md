# YARD + RSpec + VitePress: Unified Documentation Vision

## Concept

Merge the best of three worlds:
- **YARD**: Rich API documentation with method signatures, parameters, return types, cross-references
- **RSpec**: Living examples, behavior-driven documentation, test coverage
- **VitePress**: Modern UI, search, navigation, theming, performance

## Current Implementation

Your documentation already combines these elements:

✅ **RSpec Examples**: Extracted from test files automatically  
✅ **VitePress UI**: Modern, searchable, beautiful interface  
✅ **Zeitwerk Structure**: Auto-discovery mirrors code organization  
✅ **Test Coverage**: Badges and statistics from RSpec  
🔄 **YARD Integration**: Can be enhanced with method signatures and parameter docs

## Enhancement Opportunities

1. **Method Signatures**: Extract from code/YARD comments
2. **Parameter Types**: Add type hints from YARD or type inference
3. **Return Types**: Document return values
4. **Method Cards**: Rich component-based method documentation
5. **Cross-References**: Better linking between related methods

## Key Features

### 1. Method Documentation with Examples

Each method shows:
- **Signature** (YARD-style): `def by_type(type_name) -> ActiveRecord::Relation`
- **Parameters**: Type hints, descriptions, defaults
- **Returns**: Return type and description
- **Examples**: Live RSpec examples embedded inline
- **Test Coverage**: Badge showing test status

### 2. Class/Module Overview

- **Hierarchy**: Visual class inheritance tree
- **Included Modules**: Zeitwerk-style namespace visualization
- **Quick Stats**: Methods count, test coverage, last updated
- **Related Classes**: Cross-references to related components

### 3. Test-Driven Examples

- **Extracted Examples**: Every example comes from passing tests
- **Interactive Playground**: Run examples in browser (future)
- **Coverage Visualization**: See which methods are tested
- **Test File Links**: Direct links to source test files

### 4. Rich UI Elements

- **Method Cards**: Beautiful cards for each method with syntax highlighting
- **Example Tabs**: Switch between different examples
- **Code Playground**: Try code snippets inline
- **Search**: Full-text search across all documentation and examples

## Example Structure

```markdown
# Asset

<MethodCard>
  <MethodSignature>
    def by_type(type_name: String) -> ActiveRecord::Relation
  </MethodSignature>
  
  <MethodDescription>
    Queries assets filtered by asset type name.
  </MethodDescription>
  
  <Parameters>
    - `type_name` (String): The name of the asset type to filter by
  </Parameters>
  
  <Returns>
    ActiveRecord::Relation: Collection of assets matching the type
  </Returns>
  
  <Examples>
    <ExampleTab title="Basic Usage">
      ```ruby
      assets = Asset.by_type("sensor")
      expect(assets).to include(sensor_asset)
      ```
      <TestStatus badge="passing" />
      <SourceLink file="spec/models/asset_spec.rb:45" />
    </ExampleTab>
    
    <ExampleTab title="With Multiple Types">
      ```ruby
      sensors = Asset.by_type("sensor")
      actuators = Asset.by_type("actuator")
      ```
      <TestStatus badge="passing" />
      <SourceLink file="spec/models/asset_spec.rb:52" />
    </ExampleTab>
  </Examples>
  
  <RelatedMethods>
    - `Asset.by_parent`
    - `AssetType.find_by_name`
  </RelatedMethods>
</MethodCard>
```

## Visual Design

- **Method Cards**: Clean, card-based layout
- **Syntax Highlighting**: Beautiful code blocks
- **Interactive Elements**: Expandable sections, tabs
- **Dark Mode**: Full theme support
- **Responsive**: Mobile-friendly design

## Navigation

- **Sidebar**: Auto-generated from code structure (Zeitwerk-style)
- **Search**: Full-text search with instant results
- **Breadcrumbs**: Clear navigation hierarchy
- **Related Links**: Smart suggestions for related content

## Integration Points

1. **YARD Comments**: Parse `@param`, `@return`, `@example` tags
2. **RSpec Examples**: Extract from `it` blocks automatically
3. **SimpleCov Coverage**: Show coverage metrics, uncovered lines, coverage trends
4. **VitePress Rendering**: Beautiful UI with all VitePress features
5. **Auto-generation**: Keep docs in sync with code

## SimpleCov Integration

### Coverage Visualization

- **Method-Level Coverage**: Show coverage percentage for each method
- **Line Coverage**: Highlight covered/uncovered lines
- **Coverage Badges**: Visual indicators for coverage status
- **Coverage Trends**: Track coverage over time
- **Coverage Gates**: Enforce minimum coverage requirements

### Coverage Components

- `<CoverageBadge>` - Shows coverage percentage with color coding
- `<MethodCoverage>` - Detailed coverage info for a method
- `<CoverageChart>` - Visual coverage trends
- `<UncoveredLines>` - List of uncovered lines with context
