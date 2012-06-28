require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleSection < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @course = @backup.course
    @sections = @course.sections
    @section = @sections.first
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_a_course
    assert_equal @course, @section.course
  end

  def test_it_has_all_the_sections
    assert_equal 2, @sections.length
  end

  def test_it_has_an_id
    assert_equal 12345, @section.id
  end

  def test_it_has_a_number
    assert_equal 0, @section.number
  end

  def test_it_has_a_summary
    assert_equal "<h1>This is the Syllabus</h1>", @section.summary
  end

  def test_it_has_a_visibility
    assert_equal true, @section.visible
  end

  def test_mods_have_an_indent
    assert_equal 0, @section.mods[0].indent
  end

  def test_it_has_mods
    assert @section.mods.length > 0
  end

  def test_mods_have_an_id
    assert 11111, @section.mods.first.id
  end

  def test_mods_have_an_instance_id
    assert 987, @section.mods.first.instance_id
  end

  def test_mods_have_instances
    assert_equal @course.mods.first.id, @section.mods.first.instance.id
  end

  def test_mods_have_added
    assert_equal 1338410699, @section.mods.first.added
  end
end
