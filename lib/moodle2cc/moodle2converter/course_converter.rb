class Moodle2CC::Moodle2Converter::CourseConverter

  def convert(moodle_course)
    cc_course = Moodle2CC::CanvasCC::Model::Course.new
    cc_course.title = moodle_course.fullname
    cc_course.course_code = moodle_course.shortname
    cc_course.start_at = moodle_course.startdate
    cc_course.identifier = moodle_course.course_id
    cc_course.allow_student_discussion_topics = false
    cc_course.allow_student_wiki_edits = false
    cc_course
  end

end