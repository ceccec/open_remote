# PseudoClock Examples

Test-driven examples for PseudoClock functionality.

### uses UTC offset for unknown zone IDs

```ruby
    expected = Time.new(2024, 1, 1, 12, 0, 0, "+00:00")
    expect(clock.current_time_millis).to eq((expected.to_r * 1000).to_i)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/services/pseudo_clock_spec.rb:4`_


---

[← Back to Index](/)
