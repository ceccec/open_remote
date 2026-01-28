ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Override setup_fixtures to clean users_roles before fixtures load
    # This prevents foreign key violations when roles are recreated with new IDs
    def setup_fixtures
      # Clean users_roles join table before fixtures load
      # This ensures any existing users_roles records from seeds or previous tests
      # are removed before fixtures create new roles
      if ActiveRecord::Base.connection.table_exists?("users_roles")
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE users_roles RESTART IDENTITY CASCADE")
      end
      super
    end

    # Add more helper methods to be used by all tests here...
  end
end
