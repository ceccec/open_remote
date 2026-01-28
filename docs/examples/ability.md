# Ability Examples

Test-driven examples for Ability functionality.

### can manage everything

```ruby
      expect(ability).to be_able_to(:manage, :all)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_spec.rb:16`_


---

### cannot manage anything

```ruby
      expect(ability).not_to be_able_to(:manage, :all)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_spec.rb:30`_


---

### treats the user as a guest

```ruby
      expect(ability).not_to be_able_to(:manage, :all)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/models/ability_spec.rb:38`_


---

[← Back to Index](/)
