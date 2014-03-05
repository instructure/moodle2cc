module Moodle2CC::Moodle2::Parsers
  class CourseParser

    COURSE_XML_PATH = 'course/course.xml'

    def initialize(backup_folder)
      @backup_folder = backup_folder
    end

    def parse
      course = Moodle2CC::Moodle2::Models::Course.new
      File.open(File.join(@backup_folder, COURSE_XML_PATH)) do |f|
        course_doc = Nokogiri::XML(f)
        course.course_id = course_doc.at_xpath('/course/@id').value
        course.id_number = course_doc.at_xpath('/course/idnumber').text
        course.fullname = course_doc.at_xpath('/course/fullname').text
        course.shortname = course_doc.at_xpath('/course/shortname').text
        course.summary = course_doc.at_xpath('/course/summary').text
        if unix_start_date = course_doc.at_xpath('/course/startdate').text
          course.startdate = Time.at(unix_start_date.to_i)
        end

      end
      course
    end

  end
end