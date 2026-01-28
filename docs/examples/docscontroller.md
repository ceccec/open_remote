# DocsController Examples

Test-driven examples for DocsController functionality.

### serves the index.html file

```ruby
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Docs")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb:17`_


---

### sets cache control headers

```ruby
          expect(response.headers["Cache-Control"]).to include("public")
          expect(response.headers["Cache-Control"]).to include("max-age=3600")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb:28`_


---

### does not set cache control headers

```ruby
          expect(response.headers["Cache-Control"]).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb:36`_


---

### redirects to /api

```ruby
        expect(response).to redirect_to("/api")
        expect(response).to have_http_status(:found)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb:49`_


---

[← Back to Index](/)
