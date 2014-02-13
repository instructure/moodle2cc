require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2
  class CourseParserTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @course_parser = Moodle2CC::Moodle2::CourseParser.new(fixture_path(File.join('moodle2', 'backup')))
    end

    def teardown
      # Do nothing
    end

    def test_create_course
      course = @course_parser.convert
      assert_equal( 'SIS ID', course.id_number)
      assert_equal( 'Long Name', course.fullname)
      assert_equal( 'Short Name', course.shortname)
      assert_equal( Time.parse('Sat, 08 Feb 2014 16:00:00 GMT'), course.startdate)
      assert_equal( '<p>Course Summary</p>', course.summary)
      assert_equal('4', course.course_id)

    end

  end
end