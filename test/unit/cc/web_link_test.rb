require 'nokogiri'
require 'minitest/autorun'
require 'test_helper'
require 'moodle2cc'

class TestUnitCCWebLink < MiniTest::Test
  include TestHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |m| m.mod_type == "resource" && m.type == "file" }
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @mod.id = 123

    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal 123, web_link.id
  end

  def test_it_converts_title
    @mod.name = "About Your Instructor"

    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal "About Your Instructor", web_link.title
  end

  def test_it_converts_url
    @mod.reference = "http://en.wikipedia.org/wiki/Einstein"

    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal "http://en.wikipedia.org/wiki/Einstein", web_link.url
  end

  def test_it_strips_whitespace_from_url
    @mod.reference = " http://en.wikipedia.org/wiki/Einstein "

    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal "http://en.wikipedia.org/wiki/Einstein", web_link.url
  end

  def test_it_converts_external_link
    @mod.reference = "http://en.wikipedia.org/wiki/Einstein"
    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal true, web_link.external_link

    @mod.reference = "files/myfile.txt"
    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal false, web_link.external_link
  end

  def test_it_converts_external_link_with_spaces_in_the_url
    @mod.reference = "http://en.wikipedia.org/wiki/Einstein with a Space"
    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal true, web_link.external_link

    @mod.reference = "files/my file.txt"
    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal false, web_link.external_link
  end

  def test_it_converts_external_link_with_completely_invalid_url
    @mod.reference = 'http://!@#$%^&*'
    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal true, web_link.external_link

    @mod.reference = 'files/!@#$%^&*.txt'
    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal false, web_link.external_link
  end

  def test_if_converts_href
    @mod.reference = "http://en.wikipedia.org/wiki/Einstein"
    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal "#{web_link.identifier}.xml", web_link.href

    @mod.reference = "files/myfile.txt"
    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal 'web_resources/files/myfile.txt', web_link.href
  end

  def test_it_has_an_identifier_for_external_link
    @mod.id = 123

    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal 'iecc4b622fbc1adf8b8a2085e0974ac7d', web_link.identifier
  end

  def test_it_has_an_identifier_for_local_file
    @mod.reference = "files/myfile.txt"

    web_link = Moodle2CC::CC::WebLink.new @mod
    assert_equal 'i5cfabae035bff8857137d83c2a067809', web_link.identifier
  end

  def test_it_creates_resource_in_imsmanifest_for_external_link
    @mod.reference = "http://en.wikipedia.org/wiki/Einstein"
    web_link = Moodle2CC::CC::WebLink.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(web_link.create_resource_node(node))

    resource = xml.xpath('resource').first
    assert resource
    assert_equal 'imswl_xmlv1p1', resource.attributes['type'].value
    assert_equal 'i15aaccec404aa2ad557108a689bbba8f', resource.attributes['identifier'].value

    file = resource.xpath('file[@href="i15aaccec404aa2ad557108a689bbba8f.xml"]').first
    assert file
  end

  def test_it_creates_resource_in_imsmanifest_for_local_file
    @mod.reference = "files/myfile.txt"
    web_link = Moodle2CC::CC::WebLink.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(web_link.create_resource_node(node))

    resource = xml.xpath('resource').first
    assert resource
    assert_equal 'webcontent', resource.attributes['type'].value
    assert_equal 'web_resources/files/myfile.txt', resource.attributes['href'].value
    assert_equal 'i5cfabae035bff8857137d83c2a067809', resource.attributes['identifier'].value

    file = resource.xpath('file[@href="web_resources/files/myfile.txt"]').first
    assert file
  end

  def test_it_creates_xml
    @mod.id = 123
    @mod.name = "About Your Instructor"
    @mod.reference = "http://en.wikipedia.org/wiki/Einstein"

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    web_link = Moodle2CC::CC::WebLink.new @mod
    web_link.create_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, "#{web_link.identifier}.xml")))

    assert xml
    assert_equal "http://www.imsglobal.org/xsd/imsccv1p1/imswl_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imswl_v1p1.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://www.imsglobal.org/xsd/imsccv1p1/imswl_v1p1", xml.namespaces['xmlns']
    assert_equal web_link.identifier, xml.xpath('xmlns:webLink').first.attributes['identifier'].value

    assert_equal "About Your Instructor", xml.xpath('xmlns:webLink/xmlns:title').text
    assert xml.xpath('xmlns:webLink/xmlns:url[@href="http://en.wikipedia.org/wiki/Einstein"]').first
  end

  def test_it_does_not_create_xml_for_local_files
    @mod.reference = "files/myfile.txt"

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    web_link = Moodle2CC::CC::WebLink.new @mod
    web_link.create_xml(tmp_dir)
    refute File.exist?(File.join(tmp_dir, "#{web_link.identifier}.xml")), 'xml file was created for local file'
  end
end
