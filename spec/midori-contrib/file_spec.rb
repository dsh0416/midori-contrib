require './spec/spec_helper'
require 'midori-contrib/file'

RSpec.describe Midori::Contrib::File do
  describe 'extension' do
    it 'should read file in correct order' do
      answer = []
      async :test_file_read do
        file = Midori::Contrib::File.new('./Rakefile')
        answer << file.read
        file.close
        EventLoop.stop
      end
      test_file_read
      answer << 0
      EventLoop.start
      expect(answer).to eq([0, File.read('./Rakefile')])
    end

    it 'should raise error when unable to open' do
      expect {
        Midori::Contrib::File.new('./TooYoungTooSimple', 'r')
      }.to raise_error(Errno::ENOENT)
    end

    it 'should write file in correct order' do
      answer = []
      async :test_file_write do
        file = Midori::Contrib::File.new('/tmp/SometimesNaive', 'w+')
        answer << file.write('hello')
        file.close
        EventLoop.stop
      end
      test_file_write
      answer << 0
      EventLoop.start
      expect(answer).to eq([0, 5])
    end
  end

  it 'could deal with raw IO object directly' do
    file = Midori::Contrib::File.new('/tmp/SometimesNaive', 'w+')
    expect(file.raw.rewind).to eq(0)
    file.close
  end
end
