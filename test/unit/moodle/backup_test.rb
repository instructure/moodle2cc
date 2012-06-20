require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleBackup < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
  end

  def test_it_has_info
    backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    assert_instance_of Moodle2CC::Moodle::Info, backup.info
  end

  def test_it_has_a_course
    backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    assert_instance_of Moodle2CC::Moodle::Course, backup.course
  end
end
