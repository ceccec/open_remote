require "simplecov"

SimpleCov.start "rails" do
  add_filter "/spec/"
  add_filter "/app/models/concerns/admin/" # RailsAdmin configuration DSL, not business logic
  add_filter "/app/jobs/application_job.rb" # Rails boilerplate base class
  add_filter "/app/mailers/application_mailer.rb" # Rails boilerplate base class
  add_filter "/app/helpers/application_helper.rb" # Rails boilerplate helper (empty)
  # Temporarily disable coverage gate to identify actual test failures
  minimum_coverage 100
end

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods if defined?(FactoryBot)
end
