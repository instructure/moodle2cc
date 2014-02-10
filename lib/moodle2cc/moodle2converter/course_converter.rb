class Moodle2CC::Moodle2Converter::CourseConverter

  def convert(moodle_course)
    cc_course = Moodle2CC::CommonCartridge::Resource::Course.new
    cc_course.title = moodle_course.fullname

    cc_course
  end

end