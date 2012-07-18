require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCLabel < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |m| m.mod_type == "label" }
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @mod.id = 654
    label = Moodle2CC::CC::Label.new @mod
    assert_equal 654, label.id
  end

  def test_it_converts_title
    @mod.name = 'label123'
    label = Moodle2CC::CC::Label.new @mod
    assert_equal 'label123', label.title
  end
end
