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
  end

  def test_it_has_all_the_mods
    assert_equal 5, @mods.length
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
    assert_equal "<h1>Label 1</h1>", @mods[3].content
  end

  def test_it_has_an_assignment_type
    assert_equal "offline", @mods[0].assignment_type
  end

  def test_it_has_a_resubmit
    assert_equal false, @mods[0].resubmit
  end

  def test_it_has_a_prevent_late
    assert_equal false, @mods[0].prevent_late
  end

  def test_it_has_a_grade
    assert_equal 5, @mods[0].grade
  end

  def test_it_has_a_time_due
    assert_equal 0, @mods[0].time_due
  end

  def test_it_has_a_time_available
    assert_equal 0, @mods[0].time_available
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
end
