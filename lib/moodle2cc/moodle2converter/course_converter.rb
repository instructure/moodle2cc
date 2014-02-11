class Moodle2CC::Moodle2Converter::CourseConverter

  def convert(moodle_course)
    cc_course = Moodle2CC::CanvasCC::Model::Course.new
    cc_course.title = moodle_course.fullname

    cc_course
  end

end