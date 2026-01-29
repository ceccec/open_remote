# UserMailer

API documentation for UserMailer

This mailer inherits from `ApplicationMailer`, providing email composition and delivery. Mailers define email templates and can deliver synchronously or asynchronously. See [ApplicationMailer](https://api.rubyonrails.org/classes/ApplicationMailer.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationMailer](https://api.rubyonrails.org/classes/ApplicationMailer.html) - Email composition and delivery
- **Message Delivery**: [ActionMailer::MessageDelivery](https://api.rubyonrails.org/classes/ActionMailer/MessageDelivery.html) - `deliver_now`, `deliver_later`


## Examples

The following examples are extracted from test files:

### renders the headers

```ruby
      expect(mail.subject).to eq("Confirm your account")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "from@example.com" ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:19`_


### assigns confirmation_url

```ruby
      expect(mail.body.encoded).to include("test_token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:25`_


### renders the headers

```ruby
      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "from@example.com" ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:19`_


### assigns reset_password_url

```ruby
      expect(mail.body.encoded).to include("reset_token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:43`_


### renders the headers

```ruby
      expect(mail.subject).to eq("Unlock your account")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "from@example.com" ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:19`_


### assigns unlock_url

```ruby
      expect(mail.body.encoded).to include("unlock_token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:61`_


## Methods

No methods documented.

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb`

---

[← Back to Index](/)
