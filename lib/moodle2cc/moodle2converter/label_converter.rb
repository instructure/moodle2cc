module Moodle2CC
  class Moodle2Converter::LabelConverter
    include Moodle2Converter::ConverterHelper

    def convert_to_module_items(moodle_label)
      return [] unless moodle_label.convert_to_page? || moodle_label.convert_to_header?
      module_item = CanvasCC::Models::ModuleItem.new
      module_item.identifier = generate_unique_identifier
      module_item.workflow_state = workflow_state(moodle_label.visible)
      module_item.title = truncate_text(moodle_label.converted_title)
      module_item.indent = '0'

      if moodle_label.convert_to_page?
        module_item.identifierref = generate_unique_identifier_for_activity(moodle_label)
        module_item.content_type = CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE
      elsif moodle_label.convert_to_header?
        module_item.content_type = CanvasCC::Models::ModuleItem::CONTENT_TYPE_CONTEXT_MODULE_SUB_HEADER
      end

      [module_item]
    end

    def convert_to_pages(moodle_label)
      pages = []
      if moodle_label.convert_to_page?
        canvas_page = CanvasCC::Models::Page.new
        canvas_page.identifier = generate_unique_identifier_for_activity(moodle_label)
        canvas_page.title = truncate_text(moodle_label.converted_title)
        canvas_page.workflow_state = workflow_state(moodle_label.visible)
        canvas_page.editing_roles = CanvasCC::Models::Page::EDITING_ROLE_TEACHER
        canvas_page.body = moodle_label.intro
        canvas_page.href = generate_unique_resource_path(CanvasCC::Models::Page::WIKI_CONTENT,
           Moodle2CC::CanvasCC::Models::Page.convert_name_to_url(canvas_page.title))
        pages << canvas_page
      end
      pages
    end
  end
end