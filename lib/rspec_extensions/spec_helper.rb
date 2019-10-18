# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|

  # Rspec 4 defaults
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # add focus: true on a spec with guard running to 'focus'
  if ENV['_'] =~ /guard/ # make sure we don't CI that by mistake
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
  end
end
