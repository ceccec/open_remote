# Notification

API documentation for Notification

**Type:** Models  
**File:** `notification.rb`

## Associations

- `belongs_to :asset`
- `belongs_to :rule`




## Methods

- `rails_admin_label`


## Examples

The following examples are extracted from test files:

### is valid with valid attributes

```ruby
      expect(notification).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:21`_


### is invalid without message

```ruby
      expect(notification).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:32`_


### is invalid without severity

```ruby
      expect(notification).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:40`_


### is invalid without sent_at

```ruby
      expect(notification).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:48`_


### can exist without asset

```ruby
      expect(notification).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:56`_


### can exist without rule

```ruby
      expect(notification).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:66`_


### belongs to asset optionally

```ruby
      expect(notification.asset).to eq(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:78`_


### belongs to rule optionally

```ruby
      expect(notification.rule).to eq(rule)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb:88`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/notification.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/notification_spec.rb`

---

[← Back to Index](/)
