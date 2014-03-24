require 'spec_helper'

module Moodle2CC::Moodle2::Parsers
  describe GlossaryParser do
    subject(:parser) { Moodle2CC::Moodle2::Parsers::GlossaryParser.new(fixture_path(File.join('moodle2', 'backup')))}
    
    it 'parses glossaries' do
      glossaries = parser.parse
      expect(glossaries.count).to eq 1
      glossary = glossaries.first
      expect(glossary.id).to eq '1'
      expect(glossary.name).to eq 'Glossary Name'
      expect(glossary.intro).to eq  '<p>The glossary description</p>'
      expect(glossary.intro_format).to eq '1'
      expect(glossary.allow_duplicated_entries).to eq '0'
      expect(glossary.display_format).to eq 'dictionary'
      expect(glossary.main_glossary).to eq '0'
      expect(glossary.show_special).to eq '1'
      expect(glossary.show_alphabet).to eq '1'
      expect(glossary.show_all).to eq  '1'
      expect(glossary.allow_comments).to eq  '0'
      expect(glossary.allow_printview).to eq  '1'
      expect(glossary.use_dynalink).to eq  '0'
      expect(glossary.default_approval).to eq  '0'
      expect(glossary.global_glossary).to eq  '0'
      expect(glossary.ent_by_page).to eq  '10'
      expect(glossary.edit_always).to eq  '0'
      expect(glossary.rss_type).to eq '0'
      expect(glossary.rss_articles).to eq '0'
      expect(glossary.assessed).to eq '0'
      expect(glossary.assess_time_start).to eq '0'
      expect(glossary.assess_time_finish).to eq '0'
      expect(glossary.scale).to eq '0'
      expect(glossary.completion_entries).to eq '0'
    end

    it 'parses glossary entries' do
      entries = parser.parse.first.entries
      expect(entries.count).to eq 3
      entry = entries.first

      expect(entry.id).to eq '1'
      expect(entry.user_id).to eq '2'
      expect(entry.concept).to eq  'Glossary Concept'
      expect(entry.definition).to eq '<p>Definition of concept</p>'
      expect(entry.definition_format).to eq '1'
      expect(entry.definition_trust).to eq '0'
      expect(entry.attachment).to eq '1'
      expect(entry.teacher_entry).to eq '1'
      expect(entry.source_glossary_id).to eq '0'
      expect(entry.use_dynalink).to eq '0'
      expect(entry.case_sensitive).to eq '0'
      expect(entry.full_match).to eq '0'
      expect(entry.approved).to eq '1'

    end

  end
end