---
title: ApplicationCable
description: Base connection class for Action Cable.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# ApplicationCable <Badge type="warning" text="Concern" />

Base connection class for Action Cable.

Handles WebSocket connection authentication and authorization.
Each WebSocket connection is identified by the current user.

::: info File Location
**Source:** `app/channels/application_cable/channel.rb`
:::

::: tip Rails Framework
:::

## Examples

<Badge type="tip" text="1 example" />

::: tip Connection identification
```ruby
# In channels, you can access the current_user:
def subscribed
  stream_for current_user
end
```
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
