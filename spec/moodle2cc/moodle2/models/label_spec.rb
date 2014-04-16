require 'spec_helper'
module Moodle2CC::Moodle2::Models
  describe Label do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :module_id
    it_behaves_like 'it has an attribute for', :name
    it_behaves_like 'it has an attribute for', :intro
    it_behaves_like 'it has an attribute for', :intro_format
    it_behaves_like 'it has an attribute for', :visible


    describe '#process_for_conversion!' do
      it 'should use the intro text if the name has no text' do
        subject.name = '<hr>'
        subject.intro = 'use me'

        expect(subject.converted_title).to eq 'use me'
        expect(subject.convert_to_page?).to eq false
        expect(subject.convert_to_header?).to eq true
      end

      it 'should use the intro text if the name is just "Label"' do
        subject.name = 'Label'
        subject.intro = 'use me'

        expect(subject.converted_title).to eq 'use me'
        expect(subject.convert_to_page?).to eq false
        expect(subject.convert_to_header?).to eq true
      end

      it 'should use the intro text if the name was truncated' do
        subject.name = ("a" * 50) + "..."
        subject.intro = ("a" * 70)

        expect(subject.converted_title).to eq ("a" * 70)
        expect(subject.convert_to_page?).to eq false
        expect(subject.convert_to_header?).to eq true
      end

      it 'should truncate the intro text if it is too long' do
        subject.name = '<hr>'
        subject.intro = ("a" * 90)

        expect(subject.converted_title).to eq (("a" * 80) + '...')
        expect(subject.convert_to_page?).to eq true
        expect(subject.convert_to_header?).to eq false
      end

      it 'should come up with a label if there is nothing else' do
        subject.name = '<hr>'
        subject.intro = '<img src="somelinky">'

        expect(subject.converted_title).to eq Moodle2CC::Moodle2::Models::Label::DEFAULT_PAGE_TITLE
        expect(subject.convert_to_page?).to eq true
        expect(subject.convert_to_header?).to eq false
      end

      it 'should not convert to anything if there is no content' do
        subject.name = '<hr>'
        subject.intro = '<br>'

        expect(subject.convert_to_page?).to eq false
        expect(subject.convert_to_header?).to eq false
      end

      it 'should not convert to page if the name and intro have the same text' do
        subject.name = 'blah'
        subject.intro = '<p>blah</p>'

        expect(subject.convert_to_page?).to eq false
        expect(subject.convert_to_header?).to eq true
      end

      it 'should convert to page if the intro has different text' do
        subject.name = 'blah'
        subject.intro = '<p>blah blah</p>'

        expect(subject.convert_to_page?).to eq true
        expect(subject.convert_to_header?).to eq false
      end
    end
  end
end