---
title: TestExpectations::ClassMethods
description: Feature declarations for models.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# TestExpectations::ClassMethods <Badge type="warning" text="Concern" />

Feature declarations for models.
Models declare their capabilities, which are used to:
- Generate comprehensive tests
- Generate documentation
- Validate feature completeness

::: info File Location
**Source:** `app/models/test_expectations.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="9 instance methods" />

::: details View all 9 instance methods

- `feature`(feature_type: Symbol, args: Array) - Declare a feature/capability of this model.
- `validates_feature` - Declare validation features (shorthand).
- `associates_feature` - Declare association features (shorthand).
- `provides_feature` - Declare method features (shorthand).
- `scopes_feature` - Declare scope features (shorthand).
- `features_of_type` - Get all features of a specific type.
- `rails_api_info` - Compute Rails API information for documentation generation.
- `generate_test` - Generate test file content based on declared features.
- `feature_documentation` - Generate feature documentation.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
