require 'spec_helper'

describe Moodle2CC::Moodle2Converter::PageConverter do
  let(:moodle_page){Moodle2CC::Moodle2::Model::Page.new}

  it 'converts a moodle page to a canvas page' do
    moodle_page.id = 'page_id'
    moodle_page.name = 'Page Name'
    moodle_page.content = '<h2>Page Content</h2>'
    canvas_page = subject.convert(moodle_page)
    expect(canvas_page.identifier).to eq 'CC_1a63c8004d716c8b91f5b7af780555b9_PAGE'
    expect(canvas_page.title).to eq 'Page Name'
    expect(canvas_page.workflow_state).to eq 'active'
    expect(canvas_page.editing_roles).to eq 'teachers'
    expect(canvas_page.body).to eq '<h2>Page Content</h2>'
  end

  it 'replaces moodle links with canvas links' do
    moodle_page.content = '&lt;p&gt;a link to &lt;img src="@@PLUGINFILE@@/smaple_gif.gif" alt="Image Description" /&gt;&lt;/p&gt;'
    canvas_page = subject.convert(moodle_page)
    expect(canvas_page.body).to eq '&lt;p&gt;a link to &lt;img src="%24IMS_CC_FILEBASE%24/smaple_gif.gif" alt="Image Description" /&gt;&lt;/p&gt;'
  end

end