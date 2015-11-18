module Moodle2CC::Moodle2Converter
  class PageConverter
    include ConverterHelper

    def convert(moodle_page)
      canvas_page = Moodle2CC::CanvasCC::Models::Page.new
      canvas_page.identifier = generate_unique_identifier_for_activity(moodle_page)
      canvas_page.page_name = moodle_page.name
      canvas_page.workflow_state = workflow_state(moodle_page.visible)
      canvas_page.editing_roles = 'teachers'
      canvas_page.body = moodle_page.content
      canvas_page
    end

  end
end