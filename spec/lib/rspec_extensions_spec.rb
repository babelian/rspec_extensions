require 'spec_helper'
require 'rspec_extensions/spec_helper'

describe 'RSpec Extensions' do
  it 'alias_spec' do
    begin
      alias_spec('ok')
    rescue LoadError => e
      expect(e.message).to include(ENV['PWD'] + '/spec/lib/ok_spec.rb')
    end
  end
end
