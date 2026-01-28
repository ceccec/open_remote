# RuleExecutionCompareValues Examples

Test-driven examples for RuleExecutionCompareValues functionality.

### handles less than operator with numeric values

```ruby
      expect(result).to be true
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:20`_


---

### handles greater than operator with numeric values

```ruby
      expect(result).to be true
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:37`_


---

### handles equals operator with exact match

```ruby
      expect(result).to be true
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:45`_


---

### handles string numeric values with less than

```ruby
      expect(result).to be true
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:56`_


---

### handles string numeric values with greater than

```ruby
      expect(result).to be true
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:64`_


---

### handles decimal values

```ruby
      expect(result).to be true
      expect(result).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:72`_


---

### handles nil values

```ruby
      expect(result).to be false
      expect(result).to be false
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:80`_


---

### handles zero values

```ruby
      expect(result).to be false
      expect(result).to be true
      expect(result).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:91`_


---

### handles negative values

```ruby
      expect(result).to be true
      expect(result).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:102`_


---

### returns false for unknown operators

```ruby
      expect(result).to be false
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:110`_


---

### handles equals with non-numeric values

```ruby
      expect(result).to be true
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:118`_


---

### handles equals with boolean values

```ruby
      expect(result).to be true
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:129`_


---

### returns true for non-attribute-value conditions

```ruby
      expect(result).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:150`_


---

### returns true when at least one asset meets condition

```ruby
      expect(result).to be true
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:158`_


---

### returns false when no assets meet condition

```ruby
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:174`_


---

### handles assets with nil attributes_data

```ruby
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:190`_


---

### handles assets with missing attribute keys

```ruby
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:203`_


---

### handles empty assets array

```ruby
      expect(result).to be false
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/rule_execution_compare_values_spec.rb:214`_


---

[← Back to Index](/)
