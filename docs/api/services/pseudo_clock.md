# PseudoClock

# Simple pseudo clock mirroring the behaviour tested in OpenRemote's

**Type:** Services  
**File:** `pseudo_clock.rb`


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

- **Examples for this class**: 1
- **Test file**: `spec/services/pseudo_clock_spec.rb`
- **Last tested**: 2026-01-28 18:05:03

:::






## Methods

- `initialize`
- `set_time`
- `set_time_iso`
- `zone_offset_for`


## Examples

The following examples are extracted from test files:

### uses UTC offset for unknown zone IDs

```ruby
    expected = Time.new(2024, 1, 1, 12, 0, 0, "+00:00")
    expect(clock.current_time_millis).to eq((expected.to_r * 1000).to_i)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/pseudo_clock_spec.rb:4`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/services/pseudo_clock.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/pseudo_clock_spec.rb`

---

[← Back to Index](/)
