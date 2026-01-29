---
title: Admin::JsonPrettyField::ClassMethods
description: Shared concern for RailsAdmin JSONB field formatting.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Admin::JsonPrettyField::ClassMethods <Badge type="warning" text="Concern" />

Shared concern for RailsAdmin JSONB field formatting.
# Provides a helper method to configure pretty-printed JSON fields.
#
module Admin
  module JsonPrettyField
    extend ActiveSupport::Concern

::: info File Location
**Source:** `app/models/concerns/admin/json_pretty_field.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="1 instance method" />

::: details View all 1 instance method

- `json_pretty_field`(field_name: Symbol, pretty_method: Symbol) -> `void` - Configures a JSONB field to display with pretty-printing.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
