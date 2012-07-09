require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleCourse < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @course = @backup.course
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_an_id
    assert_equal 55555, @course.id
  end

  def test_it_has_a_fullname
    assert_equal "My Course", @course.fullname
  end

  def test_it_has_a_shortname
    assert_equal "EDU 101", @course.shortname
  end

  def test_it_has_a_startdate
    assert_equal 1339390800, @course.startdate
  end

  def test_it_has_a_format
    assert_equal 'weeks', @course.format
  end

  def test_it_has_a_visibility
    assert_equal true, @course.visible
  end

  def test_it_has_sections
    assert @course.sections.length > 0
  end

  def test_it_has_modules
    assert @course.mods.length > 0
  end

  def test_it_has_grade_items
    assert @course.grade_items.length > 0
  end

  def test_it_has_question_categories
    assert @course.question_categories.length > 0
  end
end
