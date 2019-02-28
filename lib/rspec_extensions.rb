def alias_spec(spec)
  return if RSpec.all_examples.any?

  spec += '_spec.rb' unless spec =~ /\.rb$/
  require File.join(File.dirname(caller.first), spec)
end
