if defined?(ActiveRecord)
  require 'rspec_extensions/matchers/have_error'

  ActiveRecord::Migration.maintain_test_schema!

  RSpec.configure do |config|
    config.include RspecExtensions::Matchers # HaveError
  end
end