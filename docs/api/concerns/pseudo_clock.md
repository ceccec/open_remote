---
title: PseudoClock
description: Simple pseudo clock mirroring the behaviour tested in OpenRemote's, Reusable concern module, includes JSON::Ext::Generator::GeneratorMethods::Object
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
head:
  - - meta
    - name: keywords
      content: PseudoClock, concern, rails, api, ruby, module, reusable, JSON::Ext::Generator::GeneratorMethods::Object, current_time_millis, initialize, set_time, set_time_iso
  - - meta
    - property: og:title
      content: PseudoClock - OpenRemote Rails API
  - - meta
    - property: og:description
      content: Simple pseudo clock mirroring the behaviour tested in OpenRemote's, Reusable concern module, includes JSON::Ext::Generator::GeneratorMethods::Object
  - - meta
    - property: og:type
      content: website
---

# PseudoClock <Badge type="warning" text="Concern" />

Simple pseudo clock mirroring the behaviour tested in OpenRemote's
`TimerService.Clock.PSEUDO` JUnit tests.

Internally the clock keeps time as milliseconds since the Unix epoch.

::: info File Location
**Source:** `app/services/pseudo_clock.rb`
:::

::: tip Rails Framework
:::

## Included Modules

- <Badge type="info" text="Module" /> `JSON::Ext::Generator::GeneratorMethods::Object`

## Instance Methods

::: details View all 4 instance methods

- `current_time_millis` -> `Integer`
- `initialize` -> `PseudoClock`
- `set_time`(date: Date, time_of_day: Time, zone_id: String) -> `void` - Set the clock using a date, a Ruby `Time` for the time-of-day, and a
- `set_time_iso`(iso_timestamp: String) -> `void` - Set the clock from an ISO-8601 timestamp string.
:::

::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />

- **Total Test Files**: 69

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
