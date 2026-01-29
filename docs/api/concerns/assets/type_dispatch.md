---
title: Assets::TypeDispatch
description: Concern providing WeatherStation attribute accessors.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Assets::TypeDispatch <Badge type="warning" text="Concern" />

Concern providing WeatherStation attribute accessors.

Delegates to Asset::Type::Weather::Station::Attributes to avoid duplication.
This module is extended on Asset instances via Assets::TypeDispatch.

::: info File Location
**Source:** `app/models/concerns/assets/type_dispatch.rb`
:::

::: tip Rails Framework

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **ActiveSupport**: [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport.html) - Utility classes and Ruby extensions

:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
