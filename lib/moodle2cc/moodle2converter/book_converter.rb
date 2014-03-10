module Moodle2CC
  class Moodle2Converter::BookConverter
    include CanvasCC::FormatHelper
    include Moodle2Converter::ConverterHelper

    def convert(moodle_book)
      canvas_module = convert_moodle_book(moodle_book)
      moodle_book.chapters.each do |chapter|
        canvas_module.module_items << convert_moodle_chapter(chapter)
      end
      canvas_module
    end

    private

    def convert_moodle_book(moodle_book)
      canvas_module = CanvasCC::Model::CanvasModule.new
      canvas_module.identifier = generate_unique_identifier()
      canvas_module.title = moodle_book.name
      canvas_module.workflow_state = CanvasCC::Model::WorkflowState::ACTIVE
      canvas_module
    end

    def convert_moodle_introduction(moodle_book)
      module_item = create_module_item_with_defaults()
      module_item.title = moodle_book.name
      module_item.indent = "0"

      page = create_page_for_module_item(module_item)
      page.body = moodle_book.intro
      module_item.resource = page

      module_item
    end

    def convert_moodle_chapter(moodle_chapter)
      module_item = create_module_item_with_defaults()
      module_item.title = moodle_chapter.title
      module_item.indent = moodle_chapter.subchapter ? '2' : '1'
      module_item.workflow_state = CanvasCC::Model::WorkflowState::UNPUBLISHED if moodle_chapter.hidden

      page = create_page_for_module_item(module_item)
      page.body = update_links(moodle_chapter.content)
      module_item.resource = page

      module_item
      #canvas_module.workflow_state = moodle_book.hidden ? CanvasCC::Model::WorkflowState::ACTIVE : CanvasCC::Model::WorkflowState::UNPUBLISHED
    end

    private

    def create_module_item_with_defaults
      module_item = CanvasCC::Model::ModuleItem.new
      module_item.identifier = generate_unique_identifier()
      module_item.content_type = CanvasCC::Model::ModuleItem::CONTENT_TYPE_WIKI_PAGE
      module_item.workflow_state = CanvasCC::Model::WorkflowState::ACTIVE
      module_item
    end

    def create_page_for_module_item(module_item)
      page = CanvasCC::Model::Page.new
      page.identifier = generate_unique_identifier()
      page.type = CanvasCC::Model::Resource::WEB_CONTENT_TYPE
      page.href = generate_unique_resource_path(CanvasCC::Model::Page::WIKI_CONTENT, module_item.title, 'html' )
      page.files = [page.href]
      page.title = module_item.title
      page.workflow_state = module_item.workflow_state
      page.editing_roles = CanvasCC::Model::Page::EDITING_ROLE_TEACHER
      page
    end
  end
end