---
title: Asset::References
description: Reference helpers for Asset model.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::References <Badge type="warning" text="Concern" />

Reference helpers for Asset model.

Provides methods for accessing and navigating associations,
building reference chains, and resolving related entities.

::: info File Location
**Source:** `app/models/asset/references.rb`
:::

::: tip Rails Framework

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **ActiveSupport**: [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport.html) - Utility classes and Ruby extensions

:::

## Examples

<Badge type="tip" text="2 examples" />

::: tip Get related data points
```ruby
asset.related_data_points
```
:::

::: tip Build reference path
```ruby
asset.reference_path
```
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
