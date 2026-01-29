---
title: Testing Experience
description: Comprehensive guide to testing in OpenRemote Rails. Learn test-driven development, RSpec workflows, 69 test files, 514 examples, and how tests generate documentation automatically.
lastUpdated: 2026-01-28T23:56:12Z
head:
  - - meta
    - name: keywords
      content: testing, rspec, test-driven development, tdd, rails testing, ruby testing, test coverage, documentation, examples, 69 tests, 514 examples, bdd
  - - meta
    - property: og:title
      content: Testing Experience - OpenRemote Rails API
  - - meta
    - property: og:description
      content: Comprehensive guide to testing in OpenRemote Rails. Learn test-driven development, RSpec workflows, 69 test files, 514 examples, and how tests generate documentation automatically.
  - - meta
    - property: og:type
      content: website
---

# Testing Experience

> **Tests are living documentation.** Every test describes how the code works, what it does, and how to use it.

## Philosophy

In OpenRemote Rails, tests serve a dual purpose:

1. **Verification**: Tests ensure code works correctly
2. **Documentation**: Tests demonstrate how to use the code

When you write a test, you're writing documentation that will never go out of date. When you read a test, you're learning how the code actually works.

## Running Tests

### Quick Test Run

```bash
# Run all tests with beautiful documentation output
bundle exec rspec

# Run tests for a specific file
bundle exec rspec spec/models/asset_spec.rb

# Run tests matching a pattern
bundle exec rspec spec/models/asset*
```

### Test-Driven Development Workflow

```bash
# 1. Write a failing test (red)
bundle exec rspec spec/models/new_feature_spec.rb

# 2. Implement the feature (green)
# ... write code ...

# 3. Refactor while keeping tests green
bundle exec rspec

# 4. Generate documentation from tests
bundle exec rake test:doc
```

### Running Only Failed Tests

After a test run, you can rerun only the failures:

```bash
bundle exec rspec --only-failures
```

This saves time during development by focusing on what needs fixing.

## Test Output Format

Tests use the **documentation format** by default, which produces human-readable output:

```
Asset
  #create
    creates an asset with valid attributes
    validates presence of name
    validates presence of asset_type_id
  #update
    updates asset attributes
    validates name uniqueness
  Associations
    belongs to AssetType
    has many DataPoints
  Concerns
    includes Assets::Querying
    includes Mapping::JsonImport
```

This format makes it easy to:
- Understand what's being tested
- See the structure of your code
- Generate documentation automatically

## Coverage Requirements

**100% code coverage is required.** This ensures:

- Every line of code is tested
- Every branch is exercised
- Every edge case is considered

When you run tests with coverage:

```bash
bundle exec rake test:coverage_doc
```

You'll get:
- A coverage report at `coverage/index.html`
- Automatic documentation generation
- A gate that fails if coverage drops below 100%

::: tip Coverage Philosophy
High coverage doesn't guarantee quality, but it ensures nothing is forgotten. Combined with good test design, it creates confidence in the codebase.
:::

## Test Structure

Tests follow RSpec conventions:

```ruby
RSpec.describe Asset do
  describe "#create" do
    it "creates an asset with valid attributes" do
      asset = Asset.create!(name: "Test", asset_type: asset_type)
      expect(asset).to be_persisted
    end
  end
end
```

The structure mirrors the code structure, making it easy to find tests for specific functionality.

## Test-Driven Documentation

Tests automatically generate documentation:

### 1. Examples Extraction

Test examples are extracted and displayed in API documentation:

```ruby
# In spec/models/asset_spec.rb
it "queries assets by type" do
  assets = Asset.by_type("sensor")
  expect(assets).to include(sensor_asset)
end
```

This becomes documentation showing how to use `Asset.by_type`.

### 2. Living Examples

Every example in the documentation comes from a passing test. This means:

- Examples are always up-to-date
- Examples are verified to work
- Examples demonstrate real usage

### 3. Automatic Updates

When you run tests, documentation is automatically regenerated:

```bash
bundle exec rake test:doc
```

This ensures documentation never goes stale.

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

:::



## Developer Workflow

### Starting a New Feature

1. **Write the test first** (red)
   ```ruby
   RSpec.describe NewFeature do
     it "does something useful" do
       # Test the behavior you want
     end
   end
   ```

2. **Run the test** (see it fail)
   ```bash
   bundle exec rspec spec/models/new_feature_spec.rb
   ```

3. **Implement the feature** (green)
   ```ruby
   class NewFeature
     def do_something_useful
       # Implementation
     end
   end
   ```

4. **Refactor** (keep it green)
   ```bash
   bundle exec rspec
   ```

5. **Generate docs** (documentation is ready)
   ```bash
   bundle exec rake test:doc
   ```

### Fixing a Bug

1. **Write a test that reproduces the bug**
   ```ruby
   it "handles edge case correctly" do
     # Test that fails due to bug
   end
   ```

2. **Fix the bug** (test passes)
3. **Run full suite** (ensure nothing broke)
   ```bash
   bundle exec rspec
   ```

4. **Documentation updates automatically**

### Understanding Existing Code

When you encounter unfamiliar code:

1. **Read the tests first**
   ```bash
   # Find the test file
   find spec -name "*asset*_spec.rb"
   ```

2. **Run the tests** (see how it's used)
   ```bash
   bundle exec rspec spec/models/asset_spec.rb
   ```

3. **Read the generated docs** (see examples)
   ```bash
   # View in browser after generating docs
   npm run docs:dev
   ```

## Test Organization

Tests mirror the application structure:

```
spec/
├── models/
│   ├── asset_spec.rb
│   └── data_point_spec.rb
├── controllers/
│   └── sessions_controller_spec.rb
├── services/
│   └── rule_manager_spec.rb
├── concerns/
│   └── batch_actions_spec.rb
└── support/
    └── shared_examples/
        └── queryable.rb
```

This makes it easy to find tests for any component.

## Continuous Integration

Tests run automatically in CI:

```bash
# CI runs:
bundle exec rake test:coverage_doc
```

This ensures:
- All tests pass
- Coverage stays at 100%
- Documentation is up-to-date

## Best Practices

### Write Descriptive Test Names

```ruby
# Good: describes what the test verifies
it "creates an asset with valid attributes"
it "validates presence of name"
it "queries assets by type"

# Bad: doesn't explain what's being tested
it "works"
it "test 1"
it "does stuff"
```

### Use Context Blocks

```ruby
describe "#update" do
  context "with valid attributes" do
    it "updates the asset"
  end

  context "with invalid attributes" do
    it "raises a validation error"
  end
end
```

### Test Behavior, Not Implementation

```ruby
# Good: tests what the code does
it "returns assets filtered by type" do
  expect(Asset.by_type("sensor").count).to eq(2)
end

# Bad: tests implementation details
it "calls where method" do
  expect(Asset).to receive(:where)
end
```

## Summary

Testing in OpenRemote Rails is designed to be:

- **Fast**: Run only what you need
- **Clear**: Documentation format shows what's tested
- **Comprehensive**: 100% coverage ensures nothing is missed
- **Documented**: Tests become documentation automatically
- **Confident**: High coverage + good tests = reliable code

::: info Next Steps
- Run `bundle exec rspec` to see tests in action
- Check `coverage/index.html` for coverage details
- View generated docs with `npm run docs:dev`
:::

---

[← Back to Index](/)
