require 'spec_helper'

module Moodle2CC::Moodle2
  describe Parsers::LabelParser do

    subject(:parser) { Parsers::LabelParser.new(fixture_path(File.join('moodle2', 'backup')))}

    it 'parses labels' do
      labels = parser.parse
      expect(labels.count).to eq 1
      label = labels.first
      expect(label.id).to eq '1'
      expect(label.name).to eq 'This is some label text'
      expect(label.intro).to eq  '<p>This is some label text</p>'
      expect(label.intro_format).to eq '1'
      expect(label.module_id).to eq '11'
      expect(label.visible).to eq true
    end

  end
end