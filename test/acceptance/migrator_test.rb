require 'minitest/autorun'
require 'test_helper'
require 'moodle2cc'

class TestAcceptanceMigrator < MiniTest::Test
  include TestHelper

  def setup
    @source = create_moodle_backup_zip
    @destination = File.expand_path("../../tmp", __FILE__)
    @package = File.expand_path("../../tmp/my-course.imscc", __FILE__)
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_creates_a_cc_package
    migrator = Moodle2CC::Migrator.new @source, @destination
    migrator.migrate
    assert File.exist?(@package), "#{@package} not created"
  end
end
