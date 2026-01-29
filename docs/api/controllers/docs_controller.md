# DocsController

# Controller to serve VitePress documentation at root.

**Type:** Controllers  
**File:** `docs_controller.rb`

This controller inherits from `ApplicationController`, handling HTTP requests, rendering, session management, strong parameters, filters, and more. See [ApplicationController](https://api.rubyonrails.org/classes/ApplicationController.html) for the complete API.
**Rails Framework References:**
- **Base Class**: [ApplicationController](https://api.rubyonrails.org/classes/ApplicationController.html) - Request handling, rendering, and controller lifecycle
- **Parameters**: [ActionController::Parameters](https://api.rubyonrails.org/classes/ActionController/Parameters.html) - Strong parameters and request data filtering
- **Routing**: [ActionDispatch::Routing](https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper.html) - URL routing and route helpers
- **Filters**: [ActionController::Filters](https://api.rubyonrails.org/classes/ActionController/Filters/ClassMethods.html) - `before_action`, `after_action`, `around_action`


::: details 📊 Coverage & Testing Statistics

### Test Suite Statistics

<Badge type="tip" text="69 test files" />
<Badge type="tip" text="514 examples" />
<Badge type="info" text="56 classes tested" />


- **Total Test Files**: 69
- **Total Examples**: 514
- **Classes Tested**: 56

**Tests by Type:**

- **Models**: 32 test files
- **Other**: 13 test files
- **Controllers**: 7 test files
- **Services**: 7 test files
- **Concerns**: 6 test files
- **Jobs**: 3 test files
- **Mailers**: 1 test file

### Class-Specific Statistics

- **Examples for this class**: 4
- **Test file**: `spec/controllers/docs_controller_spec.rb`
- **Last tested**: 2026-01-28 22:12:20

:::






## Methods

- `index`


## Examples

The following examples are extracted from test files:

### serves the index.html file

```ruby
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Docs")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb:17`_


### sets cache control headers

```ruby
          expect(response.headers["Cache-Control"]).to include("public")
          expect(response.headers["Cache-Control"]).to include("max-age=3600")
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb:28`_


### does not set cache control headers

```ruby
          expect(response.headers["Cache-Control"]).to be_nil
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb:36`_


### redirects to /api

```ruby
        expect(response).to redirect_to("/api")
        expect(response).to have_http_status(:found)
```

_Source: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb:49`_


## Source Code

See: `/Users/ceci/github/ceccec/openremote/open_remote/app/controllers/docs_controller.rb`

## Test File

See: `/Users/ceci/github/ceccec/openremote/open_remote/spec/controllers/docs_controller_spec.rb`

---

[← Back to Index](/)
