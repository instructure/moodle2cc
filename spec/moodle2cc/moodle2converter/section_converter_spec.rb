require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::SectionConverter do
    let(:moodle_section) { Moodle2::Models::Section.new }

    describe '#convert' do
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

      it 'creates a module item for the summary page' do
        subject.stub(:convert_activity) { [:module_item] }
        moodle_section.summary = 'Summary Content'

        canvas_module = subject.convert(moodle_section)

        expect(canvas_module.module_items).to eq [:module_item]
      end

      it 'does not create a module item for the summary page when there is no summary content' do
        canvas_module = subject.convert(moodle_section)

        expect(canvas_module.module_items).to eq []
      end
    end

    describe '#convert_to_summary_page' do
      it 'converts the section summary to a page' do
        subject.stub(:generate_unique_identifier).and_return('some_random_id')
        moodle_section.name = 'Name'
        moodle_section.summary = 'Summary Content'
        moodle_section.visible = true

        page = subject.convert_to_summary_page(moodle_section)

        expect(page).to be_a CanvasCC::Models::Page
        expect(page.identifier).to eq 'm2d41d8cd98f00b204e9800998ecf8427e_summary_page'
        expect(page.title).to eq 'Name'
        expect(page.workflow_state).to eq 'active'
        expect(page.editing_roles).to eq 'teachers'
        expect(page.body).to eq 'Summary Content'
        expect(page.href).to eq 'wiki_content/some_random_id/name-summary.html'
      end
    end

    describe '#convert_activity' do
      it 'uses the default converter for pages' do
        subject.stub(:convert_to_module_items) { [:module_item] }
        module_items = subject.convert_activity(Moodle2::Models::Page.new)

        expect(module_items).to eq [:module_item]
      end

      it 'uses the default converter for sections' do
        subject.stub(:convert_to_module_items) { [:module_item] }
        module_items = subject.convert_activity(moodle_section)

        expect(module_items).to eq [:module_item]
      end

      it 'uses the book converter for books' do
        Moodle2Converter::BookConverter.any_instance.stub(:convert_to_module_items) { [:module_item] }
        module_items = subject.convert_activity(Moodle2::Models::Book.new)

        expect(module_items).to eq [:module_item]
      end

      it 'uses the label converter for labels' do
        Moodle2Converter::LabelConverter.any_instance.stub(:convert_to_module_items) { [:module_item] }
        module_items = subject.convert_activity(Moodle2::Models::Label.new)

        expect(module_items).to eq [:module_item]
      end
    end

    describe '#convert_to_module_items' do
      it 'converts a moodle page to a module item' do
        subject.stub(:generate_unique_identifier) { 'some_random_id' }

        moodle_page = Moodle2::Models::Page.new
        moodle_page.id = '1'
        moodle_page.name = 'page title'
        moodle_page.visible = true

        module_items = subject.convert_to_module_items(moodle_page)
        expect(module_items.size).to eq 1

        module_item = module_items.first

        expect(module_item.identifier).to eq 'some_random_id'
        expect(module_item.workflow_state).to eq 'active'
        expect(module_item.identifierref).to eq 'm2c4ca4238a0b923820dcc509a6f75849b_page'
        expect(module_item.content_type).to eq 'WikiPage'
        expect(module_item.indent).to eq '0'
      end

      it 'converts a moodle section to a module item' do
        subject.stub(:generate_unique_identifier) { 'some_random_id' }

        moodle_section.id = '1'
        moodle_section.name = 'page title'
        moodle_section.visible = false

        module_items = subject.convert_to_module_items(moodle_section)
        expect(module_items.size).to eq 1

        module_item = module_items.first

        expect(module_item.identifier).to eq 'some_random_id'
        expect(module_item.workflow_state).to eq 'unpublished'
        expect(module_item.title).to eq 'page title'
        expect(module_item.identifierref).to eq 'm2c4ca4238a0b923820dcc509a6f75849b_summary_page'
        expect(module_item.content_type).to eq 'WikiPage'
        expect(module_item.indent).to eq '0'
      end

      it 'converts a moodle external url to a external url module item' do
        subject.stub(:generate_unique_identifier) { 'some_random_id' }

        moodle_url = Moodle2::Models::ExternalUrl.new
        moodle_url.id = '1'
        moodle_url.name = 'url title'
        moodle_url.visible = true
        moodle_url.external_url = 'http://example.com'

        module_items = subject.convert_to_module_items(moodle_url)
        expect(module_items.size).to eq 1

        module_item = module_items.first

        expect(module_item.identifier).to eq 'some_random_id'
        expect(module_item.workflow_state).to eq 'active'
        expect(module_item.title).to eq 'url title'
        expect(module_item.identifierref).to eq 'some_random_id'
        expect(module_item.content_type).to eq 'ExternalUrl'
        expect(module_item.url).to eq 'http://example.com'
        expect(module_item.indent).to eq '0'
      end

      it 'converts a moodle external url to a external url module item' do
        moodle_resource = Moodle2::Models::Resource.new
        moodle_file = Moodle2::Models::Moodle2File.new
        moodle_file.content_hash = 'some_id'
        moodle_resource.file = moodle_file

        module_items = subject.convert_to_module_items(moodle_resource)
        expect(module_items.size).to eq 1

        module_item = module_items.first

        expect(module_item.identifierref).to eq 'some_id'
      end

    end
  end
end