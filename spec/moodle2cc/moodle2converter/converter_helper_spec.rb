require 'spec_helper'

module Moodle2CC
  class DummyClass
    include Moodle2Converter::ConverterHelper
  end

  describe Moodle2Converter::ConverterHelper do
    subject {DummyClass.new}
    it 'replaces moodle links with canvas links' do
      content = '&lt;p&gt;a link to &lt;img src="@@PLUGINFILE@@/smaple_gif.gif" alt="Image Description" /&gt;&lt;/p&gt;'
      expect(subject.update_links(content)).to eq '&lt;p&gt;a link to &lt;img src="%24IMS_CC_FILEBASE%24/smaple_gif.gif" alt="Image Description" /&gt;&lt;/p&gt;'
      #moodle_page.content = '&lt;p&gt;a link to &lt;img src="@@PLUGINFILE@@/smaple_gif.gif" alt="Image Description" /&gt;&lt;/p&gt;'
      #moodle_page.name = 'Page Name'
      #canvas_page = subject.convert(moodle_page)
      #expect(canvas_page.body).to eq '&lt;p&gt;a link to &lt;img src="%24IMS_CC_FILEBASE%24/smaple_gif.gif" alt="Image Description" /&gt;&lt;/p&gt;'
    end

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
      it 'generates a uuid prefixed with m2' do
        SecureRandom.stub(:uuid) {'unique-id'}
        expect(subject.generate_unique_identifier).to eq 'm2uniqueid'
      end
    end

    describe '#generate_unique_identifier_for' do
      before(:each) {Digest::MD5.stub(:hexdigest) {'hash'}}
      it 'hashes an id prefixed with m2' do
        expect(subject.generate_unique_identifier_for('some_id')).to eq 'm2hash'
        expect(Digest::MD5).to have_received(:hexdigest).with('some_id')
      end

      it 'accepts a suffix' do
        expect(subject.generate_unique_identifier_for('some_id', 'suffix')).to eq 'm2hashsuffix'
        expect(Digest::MD5).to have_received(:hexdigest).with('some_id')
      end
    end

  end
end
