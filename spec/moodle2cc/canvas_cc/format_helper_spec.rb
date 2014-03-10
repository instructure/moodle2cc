require 'spec_helper'

module Moodle2CC::CanvasCC
  describe FormatHelper do
    class DummyClass
      include FormatHelper
    end

    subject { DummyClass.new }

    describe '#generate_unique_resource_path' do
      before(:each) do
        subject.stub(:generate_unique_identifier) { 'some_unique_hash' }
      end

      it 'generates a unique resource path' do
        path = subject.generate_unique_resource_path('my/base/path')

        expect(path).to eq 'my/base/path/some_unique_hash'
      end

      it 'uses the readable name' do
        path = subject.generate_unique_resource_path('my/base/path', 'A Readable Name')

        expect(path).to eq 'my/base/path/some_unique_hash-a-readable-name'
      end

      it 'appends the file extension' do
        path = subject.generate_unique_resource_path('my/base/path', nil, 'html')

        expect(path).to eq 'my/base/path/some_unique_hash.html'
      end
    end

    describe '#generate_unique_identifier' do
      it 'generates a uuid prefixed with CC-' do
        SecureRandom.stub(:uuid) {'unique-id'}
        expect(subject.generate_unique_identifier).to eq 'cc_unique_id'
      end
    end
  end
end
