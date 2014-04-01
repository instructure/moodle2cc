module Moodle2CC::Moodle2Converter
  class CourseConverter
    include ConverterHelper

    def convert(moodle_course)
      cc_course = Moodle2CC::CanvasCC::Models::Course.new
      cc_course.title = moodle_course.fullname
      cc_course.course_code = moodle_course.shortname
      cc_course.start_at = moodle_course.startdate
      cc_course.identifier = generate_unique_identifier_for(moodle_course.course_id, COURSE_SUFFIX)
      cc_course.allow_student_discussion_topics = false
      cc_course.allow_student_wiki_edits = false
      cc_course.default_view = 'modules'
      cc_course
    end

  end
end