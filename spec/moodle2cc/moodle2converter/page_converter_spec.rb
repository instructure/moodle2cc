require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::PageConverter do
    let(:moodle_page) { Moodle2::Model::Page.new }

    it 'converts a moodle page to a canvas page' do
      moodle_page.id = 'page_id'
      moodle_page.name = 'Page Name'
      moodle_page.content = '<h2>Page Content</h2>'
      moodle_page.visible = true
      canvas_page = subject.convert(moodle_page)
      expect(canvas_page.identifier).to eq 'm21a63c8004d716c8b91f5b7af780555b9_page'
      expect(canvas_page.title).to eq 'Page Name'
      expect(canvas_page.workflow_state).to eq 'active'
      expect(canvas_page.editing_roles).to eq 'teachers'
      expect(canvas_page.body).to eq '<h2>Page Content</h2>'
    end

    it 'replaces moodle links with canvas links' do
      moodle_page.content = 'page content'
      moodle_page.name = 'Page Name'
      canvas_page = subject.convert(moodle_page)
      expect(canvas_page.body).to eq 'page content'
    end

  end
end