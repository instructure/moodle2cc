require 'spec_helper'
module Moodle2CC::Moodle2::Models
  describe Label do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :module_id
    it_behaves_like 'it has an attribute for', :name
    it_behaves_like 'it has an attribute for', :intro
    it_behaves_like 'it has an attribute for', :intro_format

  end
end