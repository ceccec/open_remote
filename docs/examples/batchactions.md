# BatchActions Examples

Test-driven examples for BatchActions functionality.

### enables multiple rules by ID

```ruby
        expect { Rule.batch_enable([ rule1.id, rule2.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:10`_


---

### does not affect other rules

```ruby
        expect { Rule.batch_enable([ rule1.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:16`_


---

### works with ActiveRecord::Relation

```ruby
        expect { Rule.batch_enable(Rule.disabled) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


---

### returns the number of records updated

```ruby
        expect(Rule.batch_enable([ rule1.id, rule2.id ])).to eq(2)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


---

### disables multiple rules by ID

```ruby
        expect { Rule.batch_disable([ rule3.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:32`_


---

### works with ActiveRecord::Relation

```ruby
        expect { Rule.batch_disable(Rule.enabled) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


---

### returns the number of records updated

```ruby
        expect(Rule.batch_disable([ rule3.id ])).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


---

### updates multiple records with attributes

```ruby
        expect { Rule.batch_update([ rule1.id, rule2.id ], { timezone: "UTC" }) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:48`_


---

### works with ActiveRecord::Relation

```ruby
        expect { Rule.batch_update(Rule.disabled, { timezone: "UTC" }) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


---

### returns the number of records updated

```ruby
        expect(Rule.batch_update([ rule1.id ], { timezone: "UTC" })).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


---

### returns 0 if attributes are blank

```ruby
        expect(Rule.batch_update([ rule1.id ], {})).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:66`_


---

### deletes multiple records by ID

```ruby
        expect { Rule.batch_delete([ rule1.id, rule2.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:72`_


---

### works with ActiveRecord::Relation

```ruby
        expect { Rule.batch_delete(Rule.disabled) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


---

### returns the number of records deleted

```ruby
        expect(Rule.batch_delete([ rule1.id ])).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:82`_


---

### executes a method on multiple records

```ruby
        expect(results[:success]).to eq(2)
        expect(results[:failed]).to eq(0)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:88`_


---

### handles methods that don

```ruby
        expect(results[:success]).to eq(0)
        expect(results[:failed]).to eq(1)
        expect(results[:errors].first[:error]).to include("nonexistent_method")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:94`_


---

### handles errors gracefully

```ruby
        expect(results[:failed]).to eq(1)
        expect(results[:errors].first[:error]).to eq("Test error")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:101`_


---

### assigns multiple assets to a parent

```ruby
        expect { Asset.batch_assign_parent([ asset1.id, asset2.id ], parent.id) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:117`_


---

### can make assets root by passing nil

```ruby
        expect { Asset.batch_assign_parent([ asset1.id ], nil) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:123`_


---

### returns the number of records updated

```ruby
        expect(Asset.batch_assign_parent([ asset1.id ], parent.id)).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


---

### acknowledges multiple notifications

```ruby
        expect { Notification.batch_acknowledge([ notification1.id, notification2.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:140`_


---

### works with ActiveRecord::Relation

```ruby
        expect { Notification.batch_acknowledge(Notification.unacknowledged) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:21`_


---

### returns the number of records updated

```ruby
        expect(Notification.batch_acknowledge([ notification1.id ])).to eq(1)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:26`_


---

### deletes multiple data points

```ruby
        expect { DataPoint.batch_delete([ data_point1.id, data_point2.id ]) }
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/concerns/batch_actions_spec.rb:165`_


---

[← Back to Index](/)
