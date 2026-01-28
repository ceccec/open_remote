# Role Examples

Test-driven examples for Role functionality.

### requires a name

```ruby
      expect(role).not_to be_valid
      expect(role.errors[:name]).to include("can't be blank")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:5`_


---

### enforces uniqueness of name scoped to resource

```ruby
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:11`_


---

### finds an existing global role

```ruby
      expect(found.id).to eq(existing.id)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:21`_


---

### creates a new global role when missing

```ruby
      expect do
      expect(role.resource).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:27`_


---

### returns just the name for global roles

```ruby
      expect(role.rails_admin_label).to eq("custom_admin")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:37`_


---

### includes resource_type and resource name when present

```ruby
      expect(label).to include("manager")
      expect(label).to include("Asset")
      expect(label).to include("Main Park")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/role_spec.rb:42`_


---

[← Back to Index](/)
