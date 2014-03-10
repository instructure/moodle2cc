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
  end
end
