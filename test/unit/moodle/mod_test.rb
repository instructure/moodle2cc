require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleMod < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @course = @backup.course
    @mods = @course.mods
    @quiz_mod = @mods.find { |mod| mod.mod_type == 'quiz' }
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_all_the_mods
    assert_equal 7, @mods.length
  end

  def test_it_has_an_id
    assert_equal 987, @mods[0].id
  end

  def test_it_has_an_var1
    assert_equal 0, @mods[0].var1
  end

  def test_it_has_an_var2
    assert_equal 1, @mods[0].var2
  end

  def test_it_has_an_var3
    assert_equal 2, @mods[0].var3
  end

  def test_it_has_an_var4
    assert_equal 3, @mods[0].var4
  end

  def test_it_has_an_var5
    assert_equal 4, @mods[0].var5
  end

  def test_it_has_a_mod_type
    assert_equal "assignment", @mods[0].mod_type
  end

  def test_it_has_a_type
    assert_equal "file", @mods[1].type
  end

  def test_it_has_a_name
    assert_equal "Create a Rails site", @mods[0].name
  end

  def test_it_has_a_description
    assert_equal "<h1>Hello World</h1>", @mods[0].description
  end

  def test_it_has_content
    assert_equal "Section 1", @mods[3].content
  end

  def test_it_has_an_assignment_type
    assert_equal "offline", @mods[0].assignment_type
  end

  def test_it_has_a_resubmit
    assert_equal false, @mods[0].resubmit
  end

  def test_it_has_a_prevent_late
    assert_equal true, @mods[0].prevent_late
  end

  def test_it_has_a_grade
    assert_equal 5, @mods[0].grade
  end

  def test_it_has_a_time_due
    assert_equal 1355356740, @mods[0].time_due
  end

  def test_it_has_a_time_available
    assert_equal 1355314332, @mods[0].time_available
  end

  def test_it_has_a_reference
    assert_equal "http://en.wikipedia.org/wiki/Einstein", @mods[1].reference
  end

  def test_it_has_an_intro
    assert_equal "General news and announcements", @mods[2].intro
  end

  def test_it_has_alltext
    assert_equal "<p><strong> Instructor Resources </strong></p>", @mods[4].alltext
  end

  def test_it_has_time_open
    assert_equal 1339440600, @quiz_mod.time_open
  end

  def test_it_has_time_close
    assert_equal 1339527000, @quiz_mod.time_close
  end

  def test_it_has_attempts_number
    assert_equal 2, @quiz_mod.attempts_number
  end

  def test_it_has_a_grade_method
    assert_equal 1, @quiz_mod.grade_method
  end

  def test_it_has_a_password
    assert_equal 'password', @quiz_mod.password
  end

  def test_it_has_a_subnet
    assert_equal '127.0.0.1', @quiz_mod.subnet
  end

  def test_it_has_shuffle_answers
    assert_equal true, @quiz_mod.shuffle_answers
  end

  def test_it_has_section_mods
    assert_equal @course.sections.first.mods.first, @mods[0].section_mod
  end

  def test_it_has_a_grade_item
    mod = @mods.find { |m| m.id == 987 }
    grade_item = @course.grade_items.find { |g| g.item_instance == mod.id }
    assert_equal grade_item, mod.grade_item
  end
end
