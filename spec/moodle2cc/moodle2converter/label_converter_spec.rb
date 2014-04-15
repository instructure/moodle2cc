require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::LabelConverter do
    let(:moodle_label) { Moodle2::Models::Label.new }

    describe '#convert_to_module_items' do
      it 'converts a moodle label with intro content to a wiki page module item' do
        subject.stub(:generate_unique_identifier) { 'some_random_id' }

        moodle_label.id = '1'
        moodle_label.name = 'label title'
        moodle_label.intro = '<div>hey look i have html content</div>'
        moodle_label.visible = true

        module_items = subject.convert_to_module_items(moodle_label)
        expect(module_items.size).to eq 1

        module_item = module_items.first

        expect(module_item.identifier).to eq 'some_random_id'
        expect(module_item.workflow_state).to eq 'active'
        expect(module_item.title).to eq 'label title'
        expect(module_item.identifierref).to eq "m2#{Digest::MD5.hexdigest(moodle_label.id.to_s)}"
        expect(module_item.content_type).to eq 'WikiPage'
        expect(module_item.indent).to eq '0'
      end

      it 'converts a plain moodle label to a title module item' do
        subject.stub(:generate_unique_identifier) { 'some_random_id' }

        moodle_label.id = '1'
        moodle_label.name = 'label title'
        moodle_label.intro = '<hr>'
        moodle_label.visible = true

        module_items = subject.convert_to_module_items(moodle_label)
        expect(module_items.size).to eq 1

        module_item = module_items.first

        expect(module_item.identifier).to eq 'some_random_id'
        expect(module_item.workflow_state).to eq 'active'
        expect(module_item.title).to eq 'label title'
        expect(module_item.identifierref).to be_nil
        expect(module_item.content_type).to eq 'ContextModuleSubHeader'
        expect(module_item.indent).to eq '0'
      end
    end

    describe '#convert_to_pages' do
      it 'converts a moodle label with intro content to a page' do
        subject.stub(:generate_unique_identifier) { 'some_random_id' }

        moodle_label.id = '1'
        moodle_label.name = 'label title'
        moodle_label.intro = '<div>hey look i also have html content</div>'
        moodle_label.visible = true

        pages = subject.convert_to_pages(moodle_label)
        expect(pages.size).to eq 1

        page = pages.first

        expect(page.identifier).to eq "m2#{Digest::MD5.hexdigest(moodle_label.id.to_s)}"
        expect(page.workflow_state).to eq 'active'
        expect(page.title).to eq 'label title'
        expect(page.editing_roles).to eq CanvasCC::Models::Page::EDITING_ROLE_TEACHER
        expect(page.body).to eq moodle_label.intro
        expect(page.href).to end_with("label-title.html")
      end

      it 'does not convert a plain moodle label to a page' do
        subject.stub(:generate_unique_identifier) { 'some_random_id' }

        moodle_label.id = '1'
        moodle_label.name = 'label title'
        moodle_label.intro = '<hr>'
        moodle_label.visible = true

        pages = subject.convert_to_pages(moodle_label)
        expect(pages.size).to eq 0
      end
    end
  end
end