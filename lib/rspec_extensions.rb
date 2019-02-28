def alias_spec(spec)
  spec += '_spec.rb' unless spec =~ /\.rb$/
  path = File.join(File.dirname(caller.first), spec)

  # don't run if we're already running this file
  return if RSpec.configuration.files_to_run.any? {|f| path.include?(f) }

  require path
end
