require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitMoodleInfo < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    @moodle_backup_path = create_moodle_backup_zip
    @backup = Moodle2CC::Moodle::Backup.read @moodle_backup_path
    @info = @backup.info
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_a_name
    assert_equal "moodle_backup.zip", @info.name
  end
end
