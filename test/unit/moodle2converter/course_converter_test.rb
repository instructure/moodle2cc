require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2Converter
  class CourseConverterTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @course_converter = Moodle2CC::Moodle2Converter::CourseConverter.new
    end

    def teardown
      # Do nothing
    end

    def test_moodle_2_cc_course_conversion
      moodle_course = Moodle2CC::Moodle2::Model::Course.new
      #moodle_course.id_number = 'sis_id' # TODO: I don't think canvas cares about this
      moodle_course.fullname = 'Full Name'
      moodle_course.shortname = 'Short Name'
      moodle_course.startdate = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
      moodle_course.summary = 'Summary'
      moodle_course.course_id = 'course_id'
      cc_course = @course_converter.convert(moodle_course)
      assert_equal('Full Name', cc_course.title)
      assert_equal('Short Name', cc_course.course_code)
      assert_equal('2014-02-08T16:00:00', cc_course.start_at)
      assert_equal('course_id', cc_course.identifier)
    end

  end
end
