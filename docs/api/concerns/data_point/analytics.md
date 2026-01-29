---
title: DataPoint::Analytics
description: Analytics helpers for aggregating `DataPoint` records using Arel.
lastUpdated: 2026-01-28T21:47:06Z
tags:
  - concern
  - api
  - module
---

# DataPoint::Analytics <Badge type="warning" text="Concern" />

Analytics helpers for aggregating `DataPoint` records using Arel.

All methods expect the JSONB `value` column to contain a `"value"` key
that can be cast to a numeric type in PostgreSQL.

This module is intended to be included into `DataPoint`.

::: info File Location
**Source:** `app/models/data_point/analytics.rb`
:::

::: tip Rails Framework

This concern uses `ActiveSupport::Concern` providing modular behavior. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **ActiveSupport**: [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport.html) - Utility classes and Ruby extensions

:::

## Class Methods

<Badge type="info" text="4 class methods" />

::: details View all 4 class methods

- `concern_feature`(feature_type: Symbol, args: Array) - Declare a feature this concern provides.
- `enables_interaction`(interaction_type: Symbol, models: ArraySymbol, description: String) - Declare model interactions this concern enables.
- `rails_api_info` -> `Hash` - Compute Rails API information for documentation generation.
- `interactions_for_model` - Get all interactions enabled by this concern.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/api/)
