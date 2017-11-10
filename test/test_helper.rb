require "simplecov"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/autorun"
require "minitest/reporters"

ENV["RAILS_ENV"] ||= "test"

SimpleCov.start "rails" do
  add_group "Validators", "app/validators"
  add_filter "/config/"
  add_filter "/lib/tasks"
  add_filter "/test/"
  add_filter "/vendor/"
end

SimpleCov.command_name "test:units"

SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter]

Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
