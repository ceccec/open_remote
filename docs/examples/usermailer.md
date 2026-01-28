# UserMailer Examples

Test-driven examples for UserMailer functionality.

### renders the headers

```ruby
      expect(mail.subject).to eq("Confirm your account")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "from@example.com" ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:19`_


---

### assigns confirmation_url

```ruby
      expect(mail.body.encoded).to include("test_token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:25`_


---

### renders the headers

```ruby
      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "from@example.com" ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:19`_


---

### assigns reset_password_url

```ruby
      expect(mail.body.encoded).to include("reset_token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:43`_


---

### renders the headers

```ruby
      expect(mail.subject).to eq("Unlock your account")
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ "from@example.com" ])
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:19`_


---

### assigns unlock_url

```ruby
      expect(mail.body.encoded).to include("unlock_token")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/mailers/user_mailer_spec.rb:61`_


---

[← Back to Index](/)
