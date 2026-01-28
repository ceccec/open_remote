# LockByKey

# Minimal Ruby port of OpenRemote's `LockByKey` utility.

**Type:** Services  
**File:** `lock_by_key.rb`




## Methods

### `initialize`




### `lock`



**Examples:**
- handles unlock on non-existent key gracefully


### `unlock`



**Examples:**
- handles unlock on non-existent key gracefully


## Examples

The following examples are extracted from test files:

### provides per-key mutex functionality



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb:5`_


### allows different keys to be locked independently



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb:14`_


### handles unlock on non-existent key gracefully

```ruby
      expect { lock_by_key.unlock("nonexistent") }.not_to raise_error
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb:23`_


### ensures mutual exclusion for same key



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb:31`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/lock_by_key.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb`

---

[← Back to Index](/)
