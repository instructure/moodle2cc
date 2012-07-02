require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleGradeItem < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @course = @backup.course
    @grade_items = @course.grade_items
    @grade_item = @grade_items.first
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_a_course
    assert_equal @course, @grade_item.course
  end

  def test_it_has_an_instance
    mod = @course.mods.find { |mod| mod.id == 987 }
    assert_equal @grade_item.instance, mod
  end

  def test_it_has_an_id
    assert_equal 71717, @grade_item.id
  end

  def test_it_has_a_category_id
    assert_equal 17171, @grade_item.category_id
  end

  def test_it_has_an_item_name
    assert_equal 'My First Grade Item', @grade_item.item_name
  end

  def test_it_has_an_item_type
    assert_equal 'mod', @grade_item.item_type
  end

  def test_it_has_an_item_module
    assert_equal 'assignment', @grade_item.item_module
  end

  def test_it_has_an_item_instance
    assert_equal 987, @grade_item.item_instance
  end

  def test_it_has_an_item_number
    assert_equal 0, @grade_item.item_number
  end

  def test_it_has_a_grade_type
    assert_equal 2, @grade_item.grade_type
  end

  def test_it_has_a_grade_max
    assert_equal 150.0, @grade_item.grade_max
  end

  def test_it_has_a_grade_min
    assert_equal 1.0, @grade_item.grade_min
  end

  def test_it_has_a_scale_id
    assert_equal 8, @grade_item.scale_id
  end
end
