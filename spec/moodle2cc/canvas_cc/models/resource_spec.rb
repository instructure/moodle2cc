require 'spec_helper'

module Moodle2CC::CanvasCC::Models
  describe Resource do
    it_behaves_like 'it has an attribute for', :href
    it_behaves_like 'it has an attribute for', :type
    it_behaves_like 'it has an attribute for', :ident_postfix, ''

    it 'adds MD5 to identifier on #identifier=' do
      subject.identifier = 'foo_bar'
      expect(subject.instance_eval('@identifier')).to eq('CC_5c7d96a3dd7a87850a2ef34087565a6e')
    end

    it 'appends the ident_postfix when accessing the identifier' do
      subject.identifier = 'foo_bar'
      subject.ident_postfix = '_postfix'
      expect(subject.identifier).to eq('CC_5c7d96a3dd7a87850a2ef34087565a6e_postfix')
    end

    it 'removes empty attributes when value is nil' do
      subject.identifier = 'foo_bar'
      subject.ident_postfix = '_postfix'
      subject.type = 'sometype'
      expect(subject.attributes.keys.length).to eq(2)

      subject.type = nil
      expect(subject.attributes.keys.length).to eq(1)
    end
  end
end