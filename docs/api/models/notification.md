# Notification

API documentation for Notification

**Type:** Models  
**File:** `notification.rb`

## Associations

- `belongs_to :asset`
- `belongs_to :rule`




## Methods

- `_run_create_callbacks`
- `_run_destroy_callbacks`
- `_run_rollback_callbacks`
- `_run_save_callbacks`
- `_run_touch_callbacks`
- `_run_update_callbacks`
- `acknowledged`
- `autosave_associated_records_for_asset`
- `autosave_associated_records_for_rule`
- `autosave_associated_records_for_versions`
- `by_severity`
- `error`
- `for_asset`
- `for_rule`
- `info`
- `paper_trail_event`
- `paper_trail_event=`
- `paper_trail_options`
- `paper_trail_options=`
- `paper_trail_options?`
- `rails_admin_label`
- `recent`
- `unacknowledged`
- `validate_associated_records_for_versions`
- `version`
- `version=`
- `version_association_name`
- `version_association_name=`
- `version_association_name?`
- `version_class_name`
- `version_class_name=`
- `version_class_name?`
- `versions_association_name`
- `versions_association_name=`
- `versions_association_name?`
- `warning`


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
