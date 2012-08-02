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
    assert_equal 4, @sections.length
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

  def test_it_has_mods
    assert @section.mods.length > 0
  end

  def test_mods_have_an_id
    assert 11111, @section.mods[1].id
  end

  def test_mods_have_an_instance_id
    assert 987, @section.mods[1].instance_id
  end

  def test_mods_have_an_indent
    assert_equal 0, @section.mods[1].indent
  end

  def test_mods_have_a_visibility
    assert_equal true, @section.mods[1].visible
  end

  def test_mods_have_instances
    assert_equal @course.mods.first.id, @section.mods[1].instance.id
  end

  def test_mods_have_added
    assert_equal 1338410699, @section.mods[1].added
  end

  def test_mods_have_a_mod_type
    assert_equal 'assignment', @section.mods[1].mod_type
  end

  def test_first_mod_is_label_from_summary
    mod = @section.mods.first
    assert_equal "section_summary_mod_#{@section.id}", mod.id
    assert_equal "section_summary_instance_#{@section.id}", mod.instance_id
    assert_equal 'summary', mod.mod_type
    assert_equal 0, mod.indent
    assert_equal true, mod.visible
    assert_equal @section, mod.section

    instance = mod.instance
    assert_equal mod, instance.section_mod
    assert_equal "section_summary_instance_#{@section.id}", instance.id
    assert_equal 'summary', instance.mod_type
    assert_equal "This is the Syllabus", instance.name
    assert_equal "<h1>This is the Syllabus</h1>", instance.content
  end
end
