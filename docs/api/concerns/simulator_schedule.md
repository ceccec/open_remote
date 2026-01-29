---
title: SimulatorSchedule
description: Ruby port of the parts of OpenRemote's `SimulatorProtocol.Schedule` that are, Reusable concern module, includes JSON::Ext::Generator::GeneratorMethods::Object
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
head:
  - - meta
    - name: keywords
      content: SimulatorSchedule, concern, rails, api, ruby, module, reusable, JSON::Ext::Generator::GeneratorMethods::Object, start, end_time, freq, by_hour, by_minute, until_time, count, current, upcoming, initialize
  - - meta
    - property: og:title
      content: SimulatorSchedule - OpenRemote Rails API
  - - meta
    - property: og:description
      content: Ruby port of the parts of OpenRemote's `SimulatorProtocol.Schedule` that are, Reusable concern module, includes JSON::Ext::Generator::GeneratorMethods::Object
  - - meta
    - property: og:type
      content: website
---

# SimulatorSchedule <Badge type="warning" text="Concern" />

Ruby port of the parts of OpenRemote's `SimulatorProtocol.Schedule` that are
exercised by the mirrored RSpec tests.

Supports simple RFC5545-style RRULEs with:
- FREQ = DAILY, HOURLY, MINUTELY
- optional COUNT
- optional UNTIL=yyyyMMdd'T'HHmmss
- optional BYHOUR / BYMINUTE for DAILY recurrences.

::: info File Location
**Source:** `app/services/simulator_schedule.rb`
:::

::: tip Rails Framework
:::

## Included Modules

- <Badge type="info" text="Module" /> `JSON::Ext::Generator::GeneratorMethods::Object`

## Class Methods

::: details View all 2 class methods

- `get_delay`(offset_seconds: Integer, time_since_occurrence_start_ms: Integer, schedule: SimulatorSchedule) -> `Integer` - Ruby equivalent of Java's Schedule.getDelay.
- `get_time_until_next_occurrence` - Ruby equivalent of Java's Schedule.getTimeUntilNextOccurrence.
:::

## Instance Methods

::: details View all 12 instance methods

- `start` - Returns the value of attribute start.
- `end_time` - Returns the value of attribute end_time.
- `freq` - Returns the value of attribute freq.
- `by_hour` - Returns the value of attribute by_hour.
- `by_minute` - Returns the value of attribute by_minute.
- `until_time` - Returns the value of attribute until_time.
- `count` - Returns the value of attribute count.
- `current` - Returns the value of attribute current.
- `upcoming` - Returns the value of attribute upcoming.
- `initialize` -> `SimulatorSchedule`
- `try_advance_active`(millis_since_epoch: Integer, tz_offset: Integer) -> `Integer` - Rough equivalent of Java's tryAdvanceActive.
- `is_after_schedule_end`
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
