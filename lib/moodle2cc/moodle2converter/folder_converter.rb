module Moodle2CC::Moodle2Converter
  class FolderConverter
    include ConverterHelper

    def initialize(moodle_course)
      @moodle_course = moodle_course
    end

    def convert(moodle_folder)
      canvas_page = Moodle2CC::CanvasCC::Models::Page.new
      canvas_page.identifier = generate_unique_identifier_for_activity(moodle_folder)
      canvas_page.page_name = moodle_folder.name
      canvas_page.workflow_state = workflow_state(moodle_folder.visible)
      canvas_page.editing_roles = 'teachers'
      canvas_page.body = generate_body(moodle_folder)
      canvas_page
    end

    private

    def parse_files_from_course(moodle_folder)
      @moodle_course.files.select { |f| moodle_folder.file_ids.include? f.id }
    end

    def generate_body(moodle_folder)
      files = sort_files(parse_files_from_course(moodle_folder))
      html = moodle_folder.intro.to_s
      html += "<ul>\n"
      files.each do |f|
        #create a moodle style link that will be replaced in the html converter
        link = "<a href=\"@@PLUGINFILE@@#{f.file_path}#{f.file_name}\">#{f.file_path[1..-1]}#{f.file_name}</a>"
        html += "<li><p>#{link}</p></li>\n"
      end
      html += "</ul>\n"
      html.strip
    end

    def sort_files(files)
      files.sort do |a, b|
        a_depth = a.file_path.scan(/\//).count
        b_depth = b.file_path.scan(/\//).count
        if a_depth == b_depth
          "#{a.file_path[1..-1]}#{a.file_name}" <=> "#{b.file_path[1..-1]}#{b.file_name}"
        else
          a_depth <=> b_depth
        end
      end
    end

  end
end