require 'spec_helper'

module Moodle2CC::Moodle2::Parsers
  describe SectionParser do

    it 'should parse sections' do
      section_parser = SectionParser.new(fixture_path(File.join('moodle2', 'backup')))
      sections = section_parser.parse
      section = sections.first

      expect(section.position).to eq(0)
      expect(section.number).to eq('0')
      expect(section.name).to eq('This is the General Summary')
      expect(section.summary).to eq('<p>This is the General Summary</p>')
      expect(section.summary_format).to eq('1')
      expect(section.sequence).to eq(['1', '11'])
      expect(section.visible).to be_true
      expect(section.available_from).to eq('0')
      expect(section.available_until).to eq('0')
      expect(section.show_availability).to eq('0')
      expect(section.grouping_id).to eq('0')
      expect(sections[3].position).to eq(3)
      expect(sections[1].visible).to be_false
    end

  end
end