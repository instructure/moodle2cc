require 'spec_helper'

module Moodle2CC::Moodle2::Parsers
  describe ResourceParser do
    subject(:parser) { ResourceParser.new(fixture_path(File.join('moodle2', 'backup'))) }

    it 'parses a moodle2 resource' do
      resources = parser.parse

      expect(resources.count).to eq 2
      resource = resources.first
      expect(resource).to be_a Moodle2CC::Moodle2::Models::Resource
      expect(resource.id).to eq "1"
      expect(resource.intro).to eq ""
      expect(resource.intro_format).to eq "1"
      expect(resource.to_be_migrated).to eq "0"
      expect(resource.legacy_files).to eq "0"
      expect(resource.legacy_files_last).to be_nil
      expect(resource.display).to eq "0"
      expect(resource.display_options).to eq 'a:2:{s:12:"printheading";i:0;s:10:"printintro";i:0;}'
      expect(resource.filter_files).to eq "0"
      expect(resource.visible).to eq true
    end

  end
end
