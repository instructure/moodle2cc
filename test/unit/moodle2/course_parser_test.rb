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
      assert_equal(course.id_number, 'SIS ID')
      assert_equal(course.fullname, 'Long Name')
      assert_equal(course.shortname, 'Short Name')
      assert_equal(course.startdate, Time.parse('Sat, 08 Feb 2014 16:00:00 GMT'))
      assert_equal(course.summary, '<p>Course Summary</p>')
    end

  end
end