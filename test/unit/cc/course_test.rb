require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCCourse < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @course = @backup.course
    @cc_course = Moodle2CC::CC::Course.new @course
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_format
    @course.format = 'weeks'
    cc_course = Moodle2CC::CC::Course.new @course
    assert_equal 'Week', cc_course.format

    @course.format = 'weekscss'
    cc_course = Moodle2CC::CC::Course.new @course
    assert_equal 'Week', cc_course.format

    @course.format = 'social'
    cc_course = Moodle2CC::CC::Course.new @course
    assert_equal 'Topic', cc_course.format

    @course.format = 'topics'
    cc_course = Moodle2CC::CC::Course.new @course
    assert_equal 'Topic', cc_course.format
  end
end
