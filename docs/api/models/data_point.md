# DataPoint

# Time-series measurement captured for a single `Asset`.

**Type:** Models  
**File:** `data_point.rb`

## Associations

- `belongs_to :asset`


## Included Modules

- `DataPoint::Analytics`



## Methods

- `rails_admin_label`


## Examples

The following examples are extracted from test files:

### includes asset name, attribute_name and formatted timestamp

```ruby
      expect(label).to include("Main Park")
      expect(label).to include("powerOutput")
      expect(label).to include("2026-01-28 15:45")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_label_spec.rb:5`_


### is valid with valid attributes

```ruby
      expect(data_point).to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:14`_


### is invalid without attribute_name

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:24`_


### is invalid without value

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:33`_


### is invalid without timestamp

```ruby
      expect(data_point).not_to be_valid
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:42`_


### belongs to asset

```ruby
      expect(data_point.asset).to eq(asset)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:53`_


### calculates sum for time range

```ruby
      expect(sum).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:76`_


### calculates average for time range

```ruby
      expect(avg).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:88`_


### finds max value for time range

```ruby
      expect(max).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:100`_


### finds min value for time range

```ruby
      expect(min).to be > 0
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:112`_


### returns neutral values when there are no matching datapoints

```ruby
      expect(sum).to eq(0.0)
      expect(avg).to be_nil
      expect(max).to be_nil
      expect(min).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:124`_


### logs a warning instead of raising when continuous aggregate creation fails

```ruby
      expect(Rails.logger).to receive(:warn).with(
      expect do
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_spec.rb:159`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/models/data_point.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/data_point_label_spec.rb`

---

[← Back to Index](/)
