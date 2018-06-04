def alias_spec(spec)
  return unless ENV['_'] =~ /guard/
  spec += '_spec.rb' unless spec =~ /\.rb$/
  require File.join(File.dirname(caller.first), spec)
end
