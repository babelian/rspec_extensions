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

  #
  # Focus
  #

  # add focus: true on a spec with guard running to 'focus'
  if ENV['_'].to_s.match?(/guard/) # make sure we don't CI that by mistake
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
  end

  # another option instead of example_count: "if config.files_to_run.one?"

  config.before do |example|
    clear_screen if example.metadata[:focus] && RSpec.world.example_count == 1
  end

  config.before do |example|
    @focus = example.metadata[:focus]
  end

  # puts that will only run if focus: true
  def putsf(*args)
    return unless @focus

    puts(*args)
  end

  ERASE_SCOLLBACK = "\e[3J".freeze
  CURSOR_HOME = "\e[H".freeze
  ERASE_DISPLAY = "\e[2J".freeze
  CLEAR_SCREEN = ERASE_SCOLLBACK + CURSOR_HOME + ERASE_DISPLAY

  def clear_screen
    puts CLEAR_SCREEN
  end
end

def alias_spec(spec)
  spec += '_spec.rb' unless spec =~ /\.rb$/
  path = File.join(File.dirname(caller.first), spec)

  # don't run if we're already running this file
  return if RSpec.configuration.files_to_run.any? {|f| path.include?(f) }

  require path
end
