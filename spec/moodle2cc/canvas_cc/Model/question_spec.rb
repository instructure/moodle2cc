require 'spec_helper'

module Moodle2CC::CanvasCC::Model
  describe Question do
    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :title
  end
end