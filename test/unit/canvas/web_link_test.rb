require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCanvasWebLink < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup 'canvas'
    @mod = @backup.course.mods.find { |m| m.mod_type == "resource" && m.type == "file" }
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_inherits_from_cc
    assert Moodle2CC::Canvas::WebLink.ancestors.include?(Moodle2CC::CC::WebLink), 'does not inherit from base CC class'
  end


  def test_it_creates_item_in_module_meta
    @mod.reference = "http://www.google.com/some-doc.html"
    web_link = Moodle2CC::Canvas::WebLink.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(web_link.create_module_meta_item_node(node, 5))

    assert_equal 'item', xml.root.name
    assert_equal 'i966437b815a49aad86a356bc8aa8f24a', xml.root.attributes['identifier'].value
    assert_equal "About Your Instructor", xml.root.xpath('title').text
    assert_equal '5', xml.root.xpath('position').text
    assert_equal '', xml.root.xpath('new_tab').text
    assert_equal '1', xml.root.xpath('indent').text
    assert_equal 'http://www.google.com/some-doc.html', xml.root.xpath('url').text
    assert_equal 'ExternalUrl', xml.root.xpath('content_type').text
    assert_equal 'i15aaccec404aa2ad557108a689bbba8f', xml.root.xpath('identifierref').text

    @mod.reference = "some/local/file.html"
    web_link = Moodle2CC::Canvas::WebLink.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(web_link.create_module_meta_item_node(node, 5))

    assert_equal '', xml.root.xpath('url').text
    assert_equal 'Attachment', xml.root.xpath('content_type').text
  end

end
