# Auto-Generated Documentation

All documentation in this project is **automatically generated** from:

1. **Model feature declarations** - Models declare their capabilities
2. **Concern interaction declarations** - Concerns declare model interactions  
3. **Test examples** - Executable documentation from tests
4. **Code structure** - Architecture patterns from code

## Generated Files

All documentation is compiled in `docs/` and then built by VitePress to `public/docs/`.

### Main Documentation (in `docs/`)

- **`README.md`** - Project overview, features, quick start, architecture summary
- **`docs/model_features.md`** - Features declared by each model
- **`docs/model_interactions.md`** - How models interact via concerns
- **`docs/capabilities.md`** - Full application capabilities extracted from tests
- **`docs/architecture.md`** - System architecture overview
- **`docs/api/index.md`** - API documentation index
- **`docs/.vitepress/config.js`** - Auto-generated VitePress configuration

### Built Documentation (in `public/docs/`)

VitePress builds all documentation from `docs/` to `public/docs/`:
- All markdown files are processed and built
- Static assets are compiled
- Accessible at `/docs/` in production

### Auto-Generation

All documentation is regenerated automatically:

- **After tests**: Run `bundle exec rspec` (if `GENERATE_DOCS != "false"`)
- **Manually**: Run `rake docs:generate_all`
- **CI/CD**: Documentation is generated in CI pipelines

## How It Works

### 1. Model Feature Declarations

Models declare their features directly in code:

```ruby
class Asset < ApplicationRecord
  include TestExpectations

  feature :validates, :name, presence: true
  feature :associates, :belongs_to, :asset_type
  feature :provides, :from_openremote_json, :to_openremote_json_tree
  feature :scopes, :solar_arrays, :solar_parks
end
```

### 2. Concern Interaction Declarations

Concerns declare how models interact:

```ruby
module Mapping::JsonImport
  extend ConcernFeatures

  enables_interaction :json_import, [:Asset], 
    "Enables Asset to import from OpenRemote JSON format"
end
```

### 3. Test-Driven Documentation

Tests serve as executable documentation:

```ruby
RSpec.describe "Asset Management", type: :feature do
  it "supports multi-level asset hierarchies" do
    # This test documents the capability
  end
end
```

### 4. Code Structure Analysis

Documentation generators analyze:

- Model associations and validations
- Concern inclusions and interactions
- Test coverage and examples
- Code organization patterns

## Regenerating Documentation

### Generate All Documentation

```bash
rake docs:generate_all
```

This generates:
- README.md
- docs/model_features.md
- docs/model_interactions.md
- docs/capabilities.md
- docs/architecture.md
- docs/api/index.md

### Generate Specific Documentation

```bash
rake docs:readme          # Generate README.md
rake docs:features        # Generate model features
rake docs:interactions    # Generate interactions
rake docs:capabilities   # Generate capabilities
rake docs:architecture    # Generate architecture
rake docs:api_index       # Generate API index
```

## Benefits

1. **Always Up-to-Date** - Documentation reflects current code
2. **Single Source of Truth** - Features declared in code, not separate docs
3. **Test-Driven** - Tests document capabilities
4. **Comprehensive** - All aspects covered automatically
5. **Consistent** - Standardized format across all docs

## Adding New Documentation

When adding new features:

1. **Declare features** in models using `feature` method
2. **Declare interactions** in concerns using `enables_interaction`
3. **Write tests** that demonstrate capabilities
4. **Run generator** to update documentation

Example:

```ruby
# In app/models/new_model.rb
class NewModel < ApplicationRecord
  include TestExpectations

  feature :validates, :name, presence: true
  feature :provides, :new_method
end

# In app/models/concerns/new_concern.rb
module NewConcern
  extend ConcernFeatures

  enables_interaction :new_interaction, [:NewModel], 
    "Enables NewModel to do something new"
end

# Run generator
rake docs:generate_all
```

## Documentation Structure

### Source Files (in `docs/`)

All documentation is compiled together in `docs/`:

```
.
├── README.md                    # Main project README (auto-generated)
├── docs/
│   ├── README.md                # Documentation index (auto-generated)
│   ├── model_features.md        # Model features (auto-generated)
│   ├── model_interactions.md    # Model interactions (auto-generated)
│   ├── capabilities.md          # Capabilities from tests (auto-generated)
│   ├── architecture.md          # Architecture overview (auto-generated)
│   ├── .vitepress/
│   │   └── config.js           # VitePress config (auto-generated)
│   ├── api/                     # API documentation (auto-generated)
│   └── examples/                # Test examples (auto-generated)
```

### Built Files (in `public/docs/`)

VitePress builds from `docs/` to `public/docs/`:

```
public/
└── docs/                        # Built documentation (accessible at /docs/)
    ├── index.html
    ├── model_features.html
    ├── api/
    └── ...
```

**Build Process:**
1. All docs are generated in `docs/`
2. VitePress builds from `docs/` to `public/docs/`
3. Documentation is accessible at `/docs/` in production

## CI/CD Integration

Documentation is automatically generated in CI:

```yaml
# .github/workflows/docs.yml
- name: Generate Documentation
  run: bundle exec rake docs:generate_all
```

## See Also

- [Model Features](model_features.md) - Features declared by each model
- [Model Interactions](model_interactions.md) - How models interact via concerns
- [Capabilities](capabilities.md) - Full application capabilities from tests
