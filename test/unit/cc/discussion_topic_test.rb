require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCDiscussionTopic < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |mod| mod.mod_type == 'forum' }
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @mod.id = 567

    discussion_topic = Moodle2CC::CC::DiscussionTopic.new @mod
    assert_equal 567, discussion_topic.id
  end

  def test_it_converts_title
    @mod.name = "Announcements"

    discussion_topic = Moodle2CC::CC::DiscussionTopic.new @mod
    assert_equal "Announcements", discussion_topic.title
  end

  def test_it_converts_text
    @mod.intro = %(<h1>Hello World</h1><img src="$@FILEPHP@$$@SLASH@$folder$@SLASH@$stuff.jpg" />)

    discussion_topic = Moodle2CC::CC::DiscussionTopic.new @mod
    assert_equal %(<h1>Hello World</h1><img src="$IMS_CC_FILEBASE$/folder/stuff.jpg" />), discussion_topic.text
  end

  def test_it_has_an_identifier
    @mod.id = 123

    discussion_topic = Moodle2CC::CC::DiscussionTopic.new @mod
    assert_equal 'ifb967ca1271d3e119ae5e22d32eeae1b', discussion_topic.identifier
  end

  def test_it_creates_resource_in_imsmanifest
    discussion_topic = Moodle2CC::CC::DiscussionTopic.new @mod
    node = Builder::XmlMarkup.new
    xml = node.root do |root_node|
      discussion_topic.create_resource_node(node)
    end
    xml = Nokogiri::XML(xml)

    resource = xml.root.xpath('resource[1]').first
    assert resource
    assert_equal 'imsdt_xmlv1p1', resource.attributes['type'].value
    assert_equal 'if7091ac80f57e45c757345555327b248', resource.attributes['identifier'].value

    file = resource.xpath('file[@href="if7091ac80f57e45c757345555327b248.xml"]').first
    assert file

    assert get_imscc_file('if7091ac80f57e45c757345555327b248.xml') # topic xml
  end

  def test_it_create_topic_xml
    @mod.name = "Announcements"
    @mod.intro = "<h1>Hello World</h1>"

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    discussion_topic = Moodle2CC::CC::DiscussionTopic.new @mod
    discussion_topic.create_topic_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, "#{discussion_topic.identifier}.xml")))

    assert xml
    assert_equal "http://www.imsglobal.org/xsd/imsccv1p1/imsdt_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imsdt_v1p1.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://www.imsglobal.org/xsd/imsccv1p1/imsdt_v1p1", xml.namespaces['xmlns']

    assert_equal 'Announcements', xml.search('title').text
    assert_equal 'text/html', xml.search('text').first.attributes['texttype'].value
    assert_equal '<h1>Hello World</h1>', xml.search('text').text
  end
end
