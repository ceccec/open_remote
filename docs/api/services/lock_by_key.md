# LockByKey

# Minimal Ruby port of OpenRemote's `LockByKey` utility.

**Type:** Services  
**File:** `lock_by_key.rb`


::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 4
- **Test file**: `spec/services/lock_by_key_spec.rb`
- **Last tested**: 2026-01-28 18:09:30

:::






## Methods

- `initialize`
- `lock`

  **Examples:**
  - handles unlock on non-existent key gracefully

- `unlock`

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
