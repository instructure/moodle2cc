module Moodle2CC::Moodle2Converter
  class GlossaryConverter
    include ConverterHelper

    def initialize(moodle_course)
      @moodle_course = moodle_course
    end

    def convert(moodle_glossary)
      canvas_page = Moodle2CC::CanvasCC::Models::Page.new
      canvas_page.identifier = generate_unique_identifier_for(moodle_glossary.id) + GLOSSARY_SUFFIX
      canvas_page.page_name = moodle_glossary.name
      canvas_page.workflow_state = 'active'
      canvas_page.editing_roles = 'teachers,students'
      canvas_page.body = generate_body(moodle_glossary)
      canvas_page.workflow_state = workflow_state(moodle_glossary.visible)
      canvas_page
    end

    private

    def parse_files_from_course(moodle_glossary)
      @moodle_course.files.select { |f| moodle_glossary.file_ids.include? f.id }
    end

    def generate_body(moodle_glossary)
      html = "<h2>#{moodle_glossary.name}</h2>"
      html += '<dl>'
      entries = moodle_glossary.entries.sort_by{|entry| entry.concept.to_s.downcase}
      entries.each { |entry| html += "<dt>#{entry.concept}</dt><dd>#{entry.definition}</dd>" }
      html += '</dl>'
      html
    end


  end
end