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
      moodle_course.id_number = 'sis_id'
      moodle_course.fullname = 'Full Name'
      moodle_course.shortname = 'Short Name'
      moodle_course.startdate = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
      moodle_course.summary = 'Summary'
      cc_course = @course_converter.convert(moodle_course)
      assert_equal(cc_course.title, 'Full Name')
    end

  end
end
