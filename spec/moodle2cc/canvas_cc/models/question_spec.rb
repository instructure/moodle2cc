require 'spec_helper'

module Moodle2CC::CanvasCC::Models
  describe Question do
    it_behaves_like 'it has an attribute for', :identifier
    it_behaves_like 'it has an attribute for', :title
  end
end