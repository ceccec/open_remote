---
title: PseudoClock
description: Simple pseudo clock mirroring the behaviour tested in OpenRemote
lastUpdated: 2026-01-28T21:47:06Z
tags:
  - concern
  - api
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

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/api/)
