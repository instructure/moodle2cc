require 'spec_helper'

module Moodle2CC::CanvasCC::Models
  describe CanvasModule do

    it_behaves_like 'it has an attribute for', :title
    it_behaves_like 'it has an attribute for', :workflow_state
    it_behaves_like 'it has an attribute for', :module_items, []

    it 'adds MD5 to identifier on #identifier=' do
      subject.identifier = 'foo_bar'
      expect(subject.identifier).to eq('foo_bar')
    end

  end
end