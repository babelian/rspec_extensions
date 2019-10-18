require './lib/rspec_extensions/version'

Gem::Specification.new do |s|
  s.name = 'rspec_extensions'
  s.version = RspecExtensions::VERSION

  s.authors = 'Zachary Powell'
  s.email = 'zach@babelian.net'
  s.homepage = 'http://github.com/babelian/rspec_extensions'
  s.license = 'MIT'
  s.summary = 'Extensions for RSpec'

  s.files = Dir.glob('{lib}/**/*')
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.require_paths = %w[lib]
  s.required_ruby_version = '>= 2.6.0'
  s.rubygems_version = '3.0.1'

  s.add_development_dependency 'rspec', '3.8.0'
end
