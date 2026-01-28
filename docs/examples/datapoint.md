# DataPoint Examples

Test-driven examples for DataPoint functionality.

### is valid with valid attributes

```ruby
      expect(data_point).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:14`_


---

### is invalid without attribute_name

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:24`_


---

### is invalid without value

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:33`_


---

### is invalid without timestamp

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:42`_


---

### belongs to asset

```ruby
      expect(data_point.asset).to eq(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:53`_


---

### calculates sum for time range

```ruby
      expect(sum).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:76`_


---

### calculates average for time range

```ruby
      expect(avg).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:88`_


---

### finds max value for time range

```ruby
      expect(max).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:100`_


---

### finds min value for time range

```ruby
      expect(min).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:112`_


---

### returns neutral values when there are no matching datapoints

```ruby
      expect(sum).to eq(0.0)
      expect(avg).to be_nil
      expect(max).to be_nil
      expect(min).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:124`_


---

### logs a warning instead of raising when continuous aggregate creation fails

```ruby
      expect(Rails.logger).to receive(:warn).with(
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:159`_


---

[← Back to Index](/)
