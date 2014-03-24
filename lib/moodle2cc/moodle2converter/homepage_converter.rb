module Moodle2CC
  class Moodle2Converter::HomepageConverter
    include Moodle2Converter::ConverterHelper

    DEFAULT_TITLE = 'Front Page'

    def convert(moodle_section)
      canvas_page = CanvasCC::Models::Page.new
      canvas_page.identifier = generate_unique_identifier()
      canvas_page.title = moodle_section.name || DEFAULT_TITLE
      canvas_page.workflow_state = CanvasCC::Models::WorkflowState::ACTIVE
      canvas_page.editing_roles = CanvasCC::Models::Page::EDITING_ROLE_TEACHER
      canvas_page.body = moodle_section.summary
      canvas_page.href = File.join(CanvasCC::Models::Page::WIKI_CONTENT, 'front-page.html')

      canvas_page
    end

  end
end