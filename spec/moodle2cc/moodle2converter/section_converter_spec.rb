require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::SectionConverter do

    it 'should convert a moodle section to a canvas module' do
      moodle_section = Moodle2::Model::Section.new
      moodle_section.id = 'section_id'
      moodle_section.name = 'section_name'
      moodle_section.visible = false
      moodle_section.position = 1
      canvas_module = subject.convert(moodle_section)
      expect(canvas_module.identifier).to eq('m2730f6511535a1e4cf13e886e52b21dc9_module')
      expect(canvas_module.title).to eq('section_name')
      expect(canvas_module.workflow_state).to eq('unpublished')
    end

    it 'converts a moodle page activity to a canvas module item' do
      subject.stub(:generate_unique_identifier) {'some_random_id'}

      moodle_section = Moodle2::Models::Section.new
      moodle_page = Moodle2::Models::Page.new
      moodle_page.id = '1'
      moodle_page.name = 'page title'

      moodle_section.sequence << moodle_page.id
      moodle_section.activities << moodle_page

      canvas_module = subject.convert(moodle_section)

      expect(canvas_module.module_items.size).to eq 1
      module_item = canvas_module.module_items.first
      expect(module_item.identifier).to eq 'some_random_id'
      expect(module_item.workflow_state).to eq 'active'
      expect(module_item.title).to eq 'page title'
      expect(module_item.identifierref).to eq 'm2c4ca4238a0b923820dcc509a6f75849b_page'
      expect(module_item.content_type).to eq 'WikiPage'
      expect(module_item.indent).to eq '0'
    end
  end
end