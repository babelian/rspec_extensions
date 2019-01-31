shared_context 'freeze in time', freeze: ->(time) { time ? true : false } do
  before do |example|
    require 'timecop'
    time = example.metadata[:freeze]
    time = time.is_a?(Time) ? time : nil
    Timecop.freeze(time)
  end

  after do
    Timecop.return
  end
end
