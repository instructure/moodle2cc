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
      expect(canvas_module.identifier).to eq('module_730f6511535a1e4cf13e886e52b21dc9')
      expect(canvas_module.title).to eq('section_name')
      expect(canvas_module.workflow_state).to eq('unpublished')
    end

  end
end