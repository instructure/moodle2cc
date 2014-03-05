require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module Moodle2
  class CourseParserTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @course_parser = Moodle2CC::Moodle2::Parser::CourseParser.new(fixture_path(File.join('moodle2', 'backup')))
    end

    def teardown
      # Do nothing
    end

    def test_create_course
      course = @course_parser.parse
      assert_equal( 'sis_id_SC', course.id_number)
      assert_equal( 'Sample Course', course.fullname)
      assert_equal( 'SC', course.shortname)
      assert_equal( Time.parse('Sat, 15 Feb 2014 00:00:00 GMT'), course.startdate)
      assert_equal( '<p>This is my course summary</p>', course.summary)
      assert_equal('2', course.course_id)

    end

  end
end