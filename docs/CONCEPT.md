# YARD + RSpec + VitePress: Unified Documentation Concept

## Vision

Create documentation that combines:
1. **YARD's** rich API documentation (method signatures, parameters, types)
2. **RSpec's** living examples (test-driven, always up-to-date)
3. **VitePress's** beautiful UI (modern, fast, searchable)

## Key Principles

### 1. Single Source of Truth
- Code is the source of truth
- Documentation is generated, not manually written
- Tests provide examples automatically

### 2. Living Documentation
- Examples come from passing tests
- Documentation updates when code changes
- Coverage badges show what's tested

### 3. Rich Context
- Method signatures with type hints
- Parameter descriptions and defaults
- Return types and descriptions
- Cross-references to related methods

### 4. Beautiful Presentation
- Clean, modern UI
- Syntax-highlighted code
- Interactive elements
- Mobile-responsive design

## Structure

### Method Documentation Format

Each method gets:

```markdown
## Method Name

**Signature:** `def method_name(param: Type) -> ReturnType`

**Description:** What the method does

**Parameters:**
| Name | Type | Description | Default |
|------|------|-------------|---------|
| param | Type | Description | value |

**Returns:** `ReturnType` - Description

**Examples:**

::: code-group
```ruby [Basic Usage]
# Example code here
```

```ruby [Advanced Usage]
# More complex example
```
:::

**Test Status:** ✓ 2 passing examples
**Source:** `spec/models/example_spec.rb:45`
```

### Class Documentation Format

```markdown
# ClassName

<ClassOverview>
  - **Inherits from:** `ParentClass`
  - **Includes:** `Concern1`, `Concern2`
  - **Methods:** 15 public, 3 private
  - **Test Coverage:** 100% (12 examples)
</ClassOverview>

## Overview

Class description here...

## Class Methods

[Method cards for each class method]

## Instance Methods

[Method cards for each instance method]

## Examples

[Extracted RSpec examples]
```

## Features

### 1. Method Cards
- Beautiful card layout for each method
- Collapsible sections
- Syntax highlighting
- Copy-to-clipboard

### 2. Example Tabs
- Multiple examples per method
- Switch between examples
- Show test status
- Link to source

### 3. Cross-References
- Related methods
- Related classes
- Included modules
- Inheritance chain

### 4. Search
- Full-text search
- Method name search
- Example search
- Instant results

### 5. Navigation
- Auto-generated sidebar
- Breadcrumbs
- Related links
- Quick jump

## Implementation

### Data Sources

1. **YARD Comments** → Method signatures, parameters, descriptions
2. **RSpec Tests** → Examples, test coverage
3. **Code Analysis** → Method discovery, relationships
4. **VitePress** → UI rendering, search, navigation

### Generation Process

1. Parse Ruby files for YARD comments
2. Extract RSpec examples from test files
3. Analyze code structure (Zeitwerk)
4. Generate markdown with VitePress components
5. Build static site with VitePress

### Components

- `MethodCard.vue` - Method documentation card
- `ExampleTab.vue` - Example with tabs
- `ClassOverview.vue` - Class summary
- `TestBadge.vue` - Test status badge
- `Signature.vue` - Method signature display

## Benefits

1. **Always Up-to-Date**: Examples come from tests
2. **Rich Context**: YARD provides API details
3. **Beautiful UI**: VitePress provides modern design
4. **Easy Navigation**: Auto-generated structure
5. **Searchable**: Full-text search across all docs
6. **Fast**: Static site generation

## Example Output

See [yard-rspec-vitepress-example.md](./EXAMPLES/yard-rspec-vitepress-example.md) for a complete example.
