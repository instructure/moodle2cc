require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCanvasLabel < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup 'canvas'
    @mod = @backup.course.mods.find { |m| m.mod_type == "label" }
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_creates_item_in_module_meta
    label = Moodle2CC::Canvas::Label.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(label.create_module_meta_item_node(node, 5))

    assert_equal 'item', xml.root.name
    assert_equal 'ifcf0624ce811c812c749c53f3c914f20', xml.root.attributes['identifier'].value
    assert_equal "label123", xml.root.xpath('title').text
    assert_equal '5', xml.root.xpath('position').text
    assert_equal '', xml.root.xpath('new_tab').text
    assert_equal '1', xml.root.xpath('indent').text
    assert_equal 'ContextModuleSubHeader', xml.root.xpath('content_type').text
    refute xml.root.xpath('identifierref').first, 'label should not have identifierref'
  end
end
