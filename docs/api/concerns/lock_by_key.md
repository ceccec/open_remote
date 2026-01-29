---
title: LockByKey
description: Minimal Ruby port of OpenRemote's `LockByKey` utility., Reusable concern module, includes JSON::Ext::Generator::GeneratorMethods::Object
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
head:
  - - meta
    - name: keywords
      content: LockByKey, concern, rails, api, ruby, module, reusable, JSON::Ext::Generator::GeneratorMethods::Object, initialize, lock, unlock
  - - meta
    - property: og:title
      content: LockByKey - OpenRemote Rails API
  - - meta
    - property: og:description
      content: Minimal Ruby port of OpenRemote's `LockByKey` utility., Reusable concern module, includes JSON::Ext::Generator::GeneratorMethods::Object
  - - meta
    - property: og:type
      content: website
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
