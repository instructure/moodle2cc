require 'spec_helper'

module Moodle2CC::Moodle2::Models
  describe GlossaryEntry do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :user_id
    it_behaves_like 'it has an attribute for', :concept
    it_behaves_like 'it has an attribute for', :definition
    it_behaves_like 'it has an attribute for', :definition_format
    it_behaves_like 'it has an attribute for', :definition_trust
    it_behaves_like 'it has an attribute for', :attachment
    it_behaves_like 'it has an attribute for', :teacher_entry
    it_behaves_like 'it has an attribute for', :source_glossary_id
    it_behaves_like 'it has an attribute for', :use_dynalink
    it_behaves_like 'it has an attribute for', :case_sensitive
    it_behaves_like 'it has an attribute for', :full_match
    it_behaves_like 'it has an attribute for', :approved
    it_behaves_like 'it has an attribute for', :aliases, []
    it_behaves_like 'it has an attribute for', :ratings, []



  end
end