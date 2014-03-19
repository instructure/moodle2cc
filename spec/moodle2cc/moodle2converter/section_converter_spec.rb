require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::SectionConverter do

    describe '#convert' do
      let(:moodle_section) { Moodle2::Models::Section.new }

      it 'should convert a moodle section to a canvas module' do
        moodle_section.id = 'section_id'
        moodle_section.name = 'section_name'
        moodle_section.visible = false
        moodle_section.position = 1
        canvas_module = subject.convert(moodle_section)
        expect(canvas_module.identifier).to eq('m2730f6511535a1e4cf13e886e52b21dc9_module')
        expect(canvas_module.title).to eq('section_name')
        expect(canvas_module.workflow_state).to eq('unpublished')
      end

      it 'converts all activities to module_items' do
        subject.stub(:convert_activity) { [:module_item] }
        3.times { moodle_section.activities << [:activity] }
        canvas_module = subject.convert(moodle_section)

        expect(canvas_module.module_items).to eq [:module_item, :module_item, :module_item]
      end
    end

    describe '#convert_activity' do
      it 'uses the default converter for pages' do
        subject.stub(:convert_to_module_items) { [:module_item] }
        module_items = subject.convert_activity(Moodle2::Models::Page.new)

        expect(module_items).to eq [:module_item]
      end

      it 'uses the book converter for books' do
        Moodle2Converter::BookConverter.any_instance.stub(:convert_to_module_items) { [:module_item] }
        module_items = subject.convert_activity(Moodle2::Models::Book.new)

        expect(module_items).to eq [:module_item]
      end
    end

    describe '#convert_to_module_items' do
      it 'converts a moodle page to a module item' do
        subject.stub(:generate_unique_identifier) { 'some_random_id' }

        moodle_page = Moodle2::Models::Page.new
        moodle_page.id = '1'
        moodle_page.name = 'page title'

        module_items = subject.convert_to_module_items(moodle_page)
        expect(module_items.size).to eq 1

        module_item = module_items.first

        expect(module_item.identifier).to eq 'some_random_id'
        expect(module_item.workflow_state).to eq 'active'
        expect(module_item.title).to eq 'page title'
        expect(module_item.identifierref).to eq 'm2c4ca4238a0b923820dcc509a6f75849b_page'
        expect(module_item.content_type).to eq 'WikiPage'
        expect(module_item.indent).to eq '0'
      end
    end
  end
end