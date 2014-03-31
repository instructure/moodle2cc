require 'spec_helper'

module Moodle2CC::CanvasCC::Models
  describe ModuleItem do
    it_behaves_like 'it has an attribute for', :identifier
    it_behaves_like 'it has an attribute for', :content_type
    it_behaves_like 'it has an attribute for', :workflow_state
    it_behaves_like 'it has an attribute for', :title
    it_behaves_like 'it has an attribute for', :new_tab
    it_behaves_like 'it has an attribute for', :indent
    it_behaves_like 'it has an attribute for', :resource
    it_behaves_like 'it has an attribute for', :identifierref
    it_behaves_like 'it has an attribute for', :url
  end
end