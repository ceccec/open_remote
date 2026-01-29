---
title: LockByKey
description: Minimal Ruby port of OpenRemote's LockByKey utility.
lastUpdated: 2026-01-28T21:47:06Z
tags:
  - concern
  - api
---

# LockByKey <Badge type="warning" text="Concern" />

Minimal Ruby port of OpenRemote's `LockByKey` utility.
Provides a per-key mutex so callers can coordinate access to shared
resources identified by a String key.

::: info File Location
**Source:** `app/services/lock_by_key.rb`
:::

::: tip Rails Framework
:::

## Included Modules

- <Badge type="info" text="Module" /> `JSON::Ext::Generator::GeneratorMethods::Object`

## Instance Methods

::: details View all 3 instance methods

- `initialize` -> `LockByKey`
- `lock`(key: String) -> `void` - Acquire the lock associated with the given key, blocking if another
- `unlock`(key: String) -> `void` - Release the lock associated with the given key.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/api/)
