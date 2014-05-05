module Moodle2CC::Moodle2::Parsers
  class CourseParser
    include ParserHelper

    COURSE_XML_PATH = 'course/course.xml'
    SCALES_XML_PATH = 'scales.xml'

    def initialize(backup_folder)
      @backup_folder = backup_folder
    end

    def parse
      course = Moodle2CC::Moodle2::Models::Course.new
      File.open(File.join(@backup_folder, COURSE_XML_PATH)) do |f|
        course_doc = Nokogiri::XML(f)
        course.course_id = course_doc.at_xpath('/course/@id').value
        course.id_number = parse_text(course_doc, '/course/idnumber')
        course.fullname = parse_text(course_doc, '/course/fullname')
        course.shortname = parse_text(course_doc, '/course/shortname')
        course.summary = parse_text(course_doc, '/course/summary')
        course.show_grades = parse_boolean(course_doc, '/course/showgrades')
        if unix_start_date = parse_text(course_doc, '/course/startdate')
          course.startdate = Time.at(unix_start_date.to_i)
        end
      end

      File.open(File.join(@backup_folder, SCALES_XML_PATH)) do |f|
        scales_doc = Nokogiri::XML(f)
        scales_doc.search('scales_definition/scale').each do |node|
          course.grading_scales[node.attributes['id'].value.to_i] = parse_text(node, 'scale').split(',')
        end
      end

      course
    end


  end
end