require 'spec_helper'

module Moodle2CC::Moodle2::Models
  describe Resource do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :module_id
    it_behaves_like 'it has an attribute for', :name
    it_behaves_like 'it has an attribute for', :intro
    it_behaves_like 'it has an attribute for', :intro_format
    it_behaves_like 'it has an attribute for', :to_be_migrated
    it_behaves_like 'it has an attribute for', :legacy_files
    it_behaves_like 'it has an attribute for', :legacy_files_last
    it_behaves_like 'it has an attribute for', :display
    it_behaves_like 'it has an attribute for', :display_options
    it_behaves_like 'it has an attribute for', :filter_files
    it_behaves_like 'it has an attribute for', :visible
    it_behaves_like 'it has an attribute for', :file_ids, []

  end
end