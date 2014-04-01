require 'spec_helper'

module Moodle2CC::Moodle2::Models
  describe Glossary do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :name
    it_behaves_like 'it has an attribute for', :intro
    it_behaves_like 'it has an attribute for', :intro_format
    it_behaves_like 'it has an attribute for', :allow_duplicated_entries
    it_behaves_like 'it has an attribute for', :display_format
    it_behaves_like 'it has an attribute for', :main_glossary
    it_behaves_like 'it has an attribute for', :show_special
    it_behaves_like 'it has an attribute for', :show_alphabet
    it_behaves_like 'it has an attribute for', :show_all
    it_behaves_like 'it has an attribute for', :allow_comments
    it_behaves_like 'it has an attribute for', :allow_printview
    it_behaves_like 'it has an attribute for', :use_dynalink
    it_behaves_like 'it has an attribute for', :default_approval
    it_behaves_like 'it has an attribute for', :global_glossary
    it_behaves_like 'it has an attribute for', :ent_by_page
    it_behaves_like 'it has an attribute for', :edit_always
    it_behaves_like 'it has an attribute for', :rss_type
    it_behaves_like 'it has an attribute for', :rss_articles
    it_behaves_like 'it has an attribute for', :assessed
    it_behaves_like 'it has an attribute for', :assess_time_start
    it_behaves_like 'it has an attribute for', :assess_time_finish
    it_behaves_like 'it has an attribute for', :scale
    it_behaves_like 'it has an attribute for', :completion_entries
    it_behaves_like 'it has an attribute for', :module_id
    it_behaves_like 'it has an attribute for', :visible
    it_behaves_like 'it has an attribute for', :entries, []

  end
end