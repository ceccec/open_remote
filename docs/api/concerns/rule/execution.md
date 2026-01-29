---
title: Rule::Execution
description: Runtime behavior for executing a `Rule` against the asset graph.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Rule::Execution <Badge type="warning" text="Concern" />

Runtime behavior for executing a `Rule` against the asset graph.

This module encapsulates all decision logic, side effects (notifications,
attribute updates, logging), and execution bookkeeping.

::: info File Location
**Source:** `app/models/rule/execution.rb`
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

## Instance Methods

<Badge type="info" text="4 instance methods" />

::: details View all 4 instance methods

- `execute!` -> `void` - Execute the rule once, recording a `RuleExecution` row.
- `schedule_condition?` -> `Boolean`
- `attribute_value_condition?` -> `Boolean`
- `attribute_changed_condition?` -> `Boolean`
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
