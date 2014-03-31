require 'spec_helper'

module Moodle2CC::Moodle2::Models
  describe ExternalUrl do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :module_id
    it_behaves_like 'it has an attribute for', :name
    it_behaves_like 'it has an attribute for', :intro
    it_behaves_like 'it has an attribute for', :intro_format
    it_behaves_like 'it has an attribute for', :external_url
    it_behaves_like 'it has an attribute for', :display
    it_behaves_like 'it has an attribute for', :display_options
    it_behaves_like 'it has an attribute for', :parameters
    it_behaves_like 'it has an attribute for', :visible

  end
end