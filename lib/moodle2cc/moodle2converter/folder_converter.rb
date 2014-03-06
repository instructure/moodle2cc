module Moodle2CC::Moodle2Converter
  class FolderConverter

    def initialize(moodle_course)
      @moodle_course = moodle_course
    end

    def convert(moodle_folder)
      canvas_page = Moodle2CC::CanvasCC::Model::Page.new
      canvas_page.identifier = "folder-#{moodle_folder.id}"
      canvas_page.page_name = moodle_folder.name
      canvas_page.workflow_state = 'active'
      canvas_page.editing_roles = 'teachers'
      canvas_page.body = generate_body(moodle_folder)
      canvas_page
    end

    private

    def parse_files_from_course(moodle_folder)
      @moodle_course.files.select { |f| moodle_folder.file_ids.include? f.id }
    end

    def generate_body(moodle_folder)
      files = parse_files_from_course(moodle_folder)
      html = "<ul>\n"
      files.each do |f|
        link = "<a href=\"%IMS_CC_FILEBASE%/#{f.file_name}\">#{f.file_path}</a>"
        html += "<li><p>#{link}</p></li>\n"
      end
      html += "</ul>\n"
      html.strip
    end

  end
end