if defined?(ActiveRecord)
  require 'database_cleaner'

  RSpec.configure do |config|
    DatabaseCleaner.allow_remote_database_url = true

    config.before(:suite) do
      DatabaseCleaner.clean_with :truncation, except: %w[ar_internal_metadata]
    end

    config.before do
      DatabaseCleaner.strategy = :transaction
    end

    config.before do
      DatabaseCleaner.start
    end

    config.append_after do
      DatabaseCleaner.clean
    end
  end
end
