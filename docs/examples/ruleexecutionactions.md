# RuleExecutionActions Examples

Test-driven examples for RuleExecutionActions functionality.

### updates attribute on all target assets

```ruby
      expect(asset.attributes_data["totalPowerOutput"]).to eq(900)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:17`_


---

### handles multiple assets

```ruby
      expect(asset.reload.attributes_data["testAttribute"]).to eq("testValue")
      expect(asset2.reload.attributes_data["testAttribute"]).to eq("testValue")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:40`_


---

### initializes attributes_data if nil

```ruby
      expect(asset.attributes_data).to be_a(Hash)
      expect(asset.attributes_data["newAttribute"]).to eq("newValue")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:69`_


---

### creates notifications for all target assets

```ruby
      expect { rule.execute! }.to change { Notification.count }.by(1)
      expect(notification.asset).to eq(asset)
      expect(notification.rule).to eq(rule)
      expect(notification.message).to eq("Test notification")
      expect(notification.severity).to eq("warning")
      expect(notification.sent_at).to be_present
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:96`_


---

### uses default message when not provided

```ruby
      expect(notification.message).to eq("Notification triggered")
      expect(notification.severity).to eq("info")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:123`_


---

### uses default severity when not provided

```ruby
      expect(notification.message).to eq("Custom message")
      expect(notification.severity).to eq("info")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:146`_


---

### interpolates message template with asset attributes

```ruby
      expect(notification.message).to eq("Alert at Test Park: Test Location")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:169`_


---

### handles missing attribute placeholders gracefully

```ruby
      expect(notification.message).to eq("Alert: ${nonexistent}")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:195`_


---

### creates info notifications for logging

```ruby
      expect { rule.execute! }.to change { Notification.count }.by(1)
      expect(notification.severity).to eq("info")
      expect(notification.message).to eq("Event logged")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:220`_


---

### uses default message when not provided

```ruby
      expect(notification.message).to eq("Event logged")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:123`_


---

### detects deviations and sends notifications

```ruby
      expect { rule.execute! }.to change { Notification.count }.by(2)
      expect(notifications.map(&:asset)).to contain_exactly(high_asset, low_asset)
        expect(notification.severity).to eq("warning")
        expect(notification.message).to include("Deviation detected")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:266`_


---

### does not send notifications when deviation is below threshold

```ruby
      expect { rule.execute! }.not_to change { Notification.count }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:303`_


---

### skips when fewer than 2 assets exist

```ruby
      expect { rule.execute! }.not_to change { Notification.count }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:333`_


---

### skips when average is zero

```ruby
      expect { rule.execute! }.not_to change { Notification.count }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:351`_


---

### handles missing attribute values gracefully

```ruby
      expect { rule.execute! }.not_to change { Notification.count }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:380`_


---

### supports asset_type key in addition to assetType

```ruby
      expect { rule.execute! }.to change { Notification.count }.by(2)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:409`_


---

### updates performance ratio for SolarPark assets

```ruby
      expect(park.attributes_data["performanceRatio"]).to eq(0.75)
      expect(array.attributes_data["performanceRatio"]).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:441`_


---

### interpolates assetName placeholder

```ruby
      expect(notification.message).to eq("Alert for Test Park")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:482`_


---

### handles multiple placeholders

```ruby
      expect(notification.message).to eq("Test Park at Location A is active")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:505`_


---

### logs failed execution with error details

```ruby
      expect do
        expect { rule.execute! }.to raise_error(StandardError, "Database error")
      expect(execution.status).to eq("failed")
      expect(execution.result["error"]).to eq("Database error")
      expect(execution.result["backtrace"]).to be_an(Array)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_actions_spec.rb:534`_


---

[← Back to Index](/)
