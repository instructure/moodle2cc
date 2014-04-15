require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::GlossaryConverter do
    let(:moodle2_course) { Moodle2::Models::Course.new }
    subject { Moodle2Converter::GlossaryConverter.new(moodle2_course) }

    let(:moodle_glossary) do
      glossary = Moodle2::Models::Glossary.new
      glossary.name = 'Glossary Name'
      glossary.visible = false
      glossary.id = '1'
      2.times do |i|
        entry = Moodle2::Models::GlossaryEntry.new
        entry.concept = "Concept number #{i}"
        entry.definition = "Definition number #{i}"
        glossary.entries << entry
      end

      glossary
    end

    it 'converts a moodle glossary to a canvas page' do
      canvas_page = subject.convert(moodle_glossary)
      expect(canvas_page.identifier).to eq 'm2c4ca4238a0b923820dcc509a6f75849b_glossary'
      expect(canvas_page.title).to eq 'Glossary Name'
      expect(canvas_page.workflow_state).to eq('unpublished')
      expect(canvas_page.editing_roles).to eq('teachers,students')

      expect(canvas_page.body).to include('<h2>Glossary Name</h2>')
      expect(canvas_page.body).to include("<dt>Concept number 0</dt><dd>Definition number 0</dd>")
      expect(canvas_page.body).to include("<dt>Concept number 1</dt><dd>Definition number 1</dd>")
    end
  end
end