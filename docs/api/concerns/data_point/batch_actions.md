---
title: DataPoint::BatchActions
description: Batch actions specific to DataPoint model.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# DataPoint::BatchActions <Badge type="warning" text="Concern" />

Batch actions specific to DataPoint model.

Provides specialized batch operations for time-series data points,
such as bulk cleanup, aggregation, and archival operations.

::: info File Location
**Source:** `app/models/data_point/batch_actions.rb`
:::

::: tip Rails Framework

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **ActiveSupport**: [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport.html) - Utility classes and Ruby extensions

:::

## Examples

<Badge type="tip" text="2 examples" />

::: tip Batch cleanup old data points
```ruby
DataPoint.batch_cleanup_older_than(1.month.ago)
```
:::

::: tip Batch archive data points
```ruby
DataPoint.batch_archive([1, 2, 3])
```
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
