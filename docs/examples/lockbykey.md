# LockByKey Examples

Test-driven examples for LockByKey functionality.

### provides per-key mutex functionality



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb:5`_


---

### allows different keys to be locked independently



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb:14`_


---

### handles unlock on non-existent key gracefully

```ruby
      expect { lock_by_key.unlock("nonexistent") }.not_to raise_error
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb:23`_


---

### ensures mutual exclusion for same key



_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/lock_by_key_spec.rb:31`_


---

[← Back to Index](/)
