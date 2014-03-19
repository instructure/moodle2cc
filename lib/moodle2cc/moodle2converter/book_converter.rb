module Moodle2CC
  class Moodle2Converter::BookConverter
    include Moodle2Converter::ConverterHelper

    def convert(moodle_book)
      canvas_module = convert_moodle_book(moodle_book)
      moodle_book.chapters.each do |chapter|
        canvas_module.module_items << convert_moodle_chapter(moodle_book, chapter)
      end
      canvas_module
    end

    def convert_to_pages(moodle_book)
      pages = moodle_book.chapters.map do |moodle_chapter|
        page = create_page(moodle_chapter.title)
        page.identifier = generate_unique_identifier_for_activity(moodle_chapter)
        page.body = moodle_chapter.content
        page
      end

      if moodle_book.intro
        page = create_page(moodle_book.name)
        page.identifier = generate_unique_identifier_for_book_intro(moodle_book)
        page.body = moodle_book.intro
        pages.unshift(page)
      end

      pages
    end

    private

    def convert_moodle_book(moodle_book)
      canvas_module = CanvasCC::Models::CanvasModule.new
      canvas_module.identifier = generate_unique_identifier()
      canvas_module.title = moodle_book.name
      canvas_module.workflow_state = CanvasCC::Models::WorkflowState::ACTIVE
      canvas_module
    end

    def convert_moodle_introduction(moodle_book)
      module_item = create_module_item_with_defaults()
      module_item.title = moodle_book.name
      module_item.indent = "0"

      page = create_page_for_module_item(module_item)
      page.identifier = generate_unique_identifier_for(moodle_book.id) + INTRO_SUFFIX
      page.body = moodle_book.intro
      module_item.resource = page

      module_item
    end

    def convert_moodle_chapter(moodle_book, moodle_chapter)
      module_item = create_module_item_with_defaults()
      module_item.title = moodle_chapter.title
      module_item.indent = moodle_chapter.subchapter ? '2' : '1'
      module_item.workflow_state = CanvasCC::Models::WorkflowState::UNPUBLISHED if moodle_chapter.hidden
      module_item.identifierref = generate_unique_identifier_for_activity(moodle_chapter)

      module_item
    end

    def create_module_item_with_defaults
      module_item = CanvasCC::Models::ModuleItem.new
      module_item.identifier = generate_unique_identifier()
      module_item.content_type = CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE
      module_item.workflow_state = CanvasCC::Models::WorkflowState::ACTIVE
      module_item
    end

    def create_page(title)
      page = CanvasCC::Models::Page.new
      page.type = CanvasCC::Models::Resource::WEB_CONTENT_TYPE
      page.href = generate_unique_resource_path(CanvasCC::Models::Page::WIKI_CONTENT, title, 'html')
      page.files = [page.href]
      page.title = title
      page.workflow_state = CanvasCC::Models::WorkflowState::ACTIVE
      page.editing_roles = CanvasCC::Models::Page::EDITING_ROLE_TEACHER
      page
    end

    def generate_unique_identifier_for_book_intro(moodle_book)
      generate_unique_identifier_for(moodle_book.id, INTRO_SUFFIX)
    end
  end
end