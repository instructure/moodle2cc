require 'spec_helper'

module Moodle2CC::Moodle2::Models
  describe Folder do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :name
    it_behaves_like 'it has an attribute for', :intro
    it_behaves_like 'it has an attribute for', :intro_format
    it_behaves_like 'it has an attribute for', :revision
    it_behaves_like 'it has an attribute for', :file_ids, []

  end
end