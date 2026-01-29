---
title: ApplicationMailbox
description: Base mailbox class for routing incoming emails., Reusable concern module, includes ActionMailbox::Callbacks, ActionMailbox::Routing, JSON::Ext::Generator::Gen...
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
head:
  - - meta
    - name: keywords
      content: ApplicationMailbox, concern, rails, api, ruby, module, reusable, ActionMailbox::Callbacks, ActionMailbox::Routing, JSON::Ext::Generator::GeneratorMethods::Object
  - - meta
    - property: og:title
      content: ApplicationMailbox - OpenRemote Rails API
  - - meta
    - property: og:description
      content: Base mailbox class for routing incoming emails., Reusable concern module, includes ActionMailbox::Callbacks, ActionMailbox::Routing, JSON::Ext::Generator::Gen...
  - - meta
    - property: og:type
      content: website
---

# ApplicationMailbox <Badge type="warning" text="Concern" />

Base mailbox class for routing incoming emails.

Action Mailbox routes incoming emails to controller-like mailboxes for processing.
Configure routing using regular expressions that match email addresses.

::: info File Location
**Source:** `app/mailboxes/application_mailbox.rb`
:::

::: tip Rails Framework
:::

## Included Modules

- <Badge type="info" text="Module" /> `ActionMailbox::Callbacks`
- <Badge type="info" text="Module" /> `ActionMailbox::Routing`
- <Badge type="info" text="Module" /> `JSON::Ext::Generator::GeneratorMethods::Object`

## Examples

<Badge type="tip" text="1 example" />

::: tip Route emails to a forwards mailbox
```ruby
routing(/^save@/i => :forwards)
routing(/@replies\./i => :replies)
```
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
