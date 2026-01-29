# Documentation Build Process

## Overview

All documentation is compiled together in `docs/` and then built by VitePress to `public/docs/`.

## Workflow

### 1. Generate Documentation

All documentation is auto-generated in `docs/`:

```bash
# Generate all documentation
rake docs:generate_all
```ruby

This creates:
- `README.md` - Project overview
- `docs/model_features.md` - Model features
- `docs/model_interactions.md` - Model interactions
- `docs/capabilities.md` - Capabilities from tests
- `docs/architecture.md` - Architecture overview
- `docs/api/**` - API documentation
- `docs/examples/**` - Test examples
- `docs/.vitepress/config.js` - VitePress configuration (auto-generated)

### 2. Build with VitePress

VitePress builds from `docs/` to `public/docs/`:

```bash
# Development server (serves from docs/)
npm run docs:dev

# Build for production (builds to public/docs/)
npm run docs:build
```ruby

### 3. Access Documentation

- **Development**: `http://localhost:5173/docs/` (VitePress dev server)
- **Production**: `/docs/` (built files in `public/docs/`)
- **GitHub Pages**: Automatically deployed from `docs/`

## Configuration

### VitePress Config (`docs/.vitepress/config.js`)

**Auto-generated** from Rails components. Configuration:

- **Base Path**: `/docs/` - Documentation is served at `/docs/`
- **Output Directory**: `../public/docs` - Builds to `public/docs/`
- **Source**: `docs/` - All markdown files compiled here

### File Structure

```ruby
.
├── docs/                        # Source documentation (compiled here)
│   ├── README.md               # Documentation index
│   ├── model_features.md       # Model features
│   ├── model_interactions.md   # Model interactions
│   ├── capabilities.md         # Capabilities
│   ├── architecture.md         # Architecture
│   ├── .vitepress/
│   │   └── config.js          # Auto-generated VitePress config
│   ├── api/                    # API docs
│   └── examples/               # Test examples
│
└── public/
    └── docs/                   # Built documentation (VitePress output)
        ├── index.html
        ├── model_features.html
        └── ...
```

## Auto-Generation

All documentation files are **auto-generated**:

- ✅ `README.md` - From model features and interactions
- ✅ `docs/model_features.md` - From model feature declarations
- ✅ `docs/model_interactions.md` - From concern interactions
- ✅ `docs/capabilities.md` - From test examples
- ✅ `docs/architecture.md` - From code structure
- ✅ `docs/.vitepress/config.js` - From Rails components
- ✅ `docs/api/**` - From Rails components and tests
- ✅ `docs/examples/**` - From RSpec test files

## Regenerating

```bash
# Regenerate all documentation
rake docs:generate_all

# Regenerate specific parts
rake docs:readme
rake docs:features
rake docs:interactions
rake docs:capabilities
rake docs:vitepress_config

# Build with VitePress
npm run docs:build
```ruby

## CI/CD

Documentation is automatically:
1. Generated in CI from model features and tests
2. Built by VitePress to `public/docs/`
3. Deployed to GitHub Pages (from `docs/`)

See `.github/workflows/docs.yml` for CI configuration.
