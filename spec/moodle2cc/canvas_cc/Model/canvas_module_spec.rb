require 'spec_helper'

module Moodle2CC::CanvasCC::Model
  describe CanvasModule do

    it_behaves_like 'it has an attribute for', :title
    it_behaves_like 'it has an attribute for', :workflow_state
    it_behaves_like 'it has an attribute for', :position

    it 'adds MD5 to identifier on #identifier=' do
      subject.identifier = 'foo_bar'
      expect(subject.identifier).to eq('module_5c7d96a3dd7a87850a2ef34087565a6e')
    end

  end
end