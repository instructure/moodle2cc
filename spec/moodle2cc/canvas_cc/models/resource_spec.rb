require 'spec_helper'

module Moodle2CC::CanvasCC::Models
  describe Resource do
    it_behaves_like 'it has an attribute for', :href
    it_behaves_like 'it has an attribute for', :type

    it 'removes empty attributes when value is nil' do
      subject.identifier = 'foo_bar'
      subject.type = 'sometype'
      expect(subject.attributes.keys.length).to eq(2)

      subject.type = nil
      expect(subject.attributes.keys.length).to eq(1)
    end
  end
end