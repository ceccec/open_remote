# PseudoClock

# Simple pseudo clock mirroring the behaviour tested in OpenRemote's

**Type:** Services  
**File:** `pseudo_clock.rb`




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
