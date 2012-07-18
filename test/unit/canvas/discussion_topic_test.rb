require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCanvasDiscussionTopic < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup('canvas')
    @mod = @backup.course.mods.find { |mod| mod.mod_type == 'forum' }
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_posted_at
    @mod.section_mod.added = 1340731824

    discussion_topic = Moodle2CC::Canvas::DiscussionTopic.new @mod
    assert_equal '2012-06-26T17:30:24', discussion_topic.posted_at
  end

  def test_it_converts_position
    discussion_topic = Moodle2CC::Canvas::DiscussionTopic.new @mod, 5
    assert_equal 5, discussion_topic.position
  end

  def test_it_converts_type
    discussion_topic = Moodle2CC::Canvas::DiscussionTopic.new @mod
    assert_equal 'topic', discussion_topic.type
  end

  def test_it_has_an_identifierref
    @mod.id = 123

    discussion_topic = Moodle2CC::Canvas::DiscussionTopic.new @mod
    assert_equal 'ic2f863a4aeaa551a04dfbea65d6e72bb', discussion_topic.identifierref
  end

  def test_it_creates_resource_in_imsmanifest
    discussion_topic = Moodle2CC::Canvas::DiscussionTopic.new @mod
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

    dependency = resource.xpath('dependency[@identifierref="i05a5b1468af5e9257a2f6b0827a0bd96"]').first
    assert dependency

    resource = xml.root.xpath('resource[2]').first
    assert resource
    assert_equal 'associatedcontent/imscc_xmlv1p1/learning-application-resource', resource.attributes['type'].value
    assert_equal 'i05a5b1468af5e9257a2f6b0827a0bd96', resource.attributes['identifier'].value
    assert_equal 'i05a5b1468af5e9257a2f6b0827a0bd96.xml', resource.attributes['href'].value

    file = resource.xpath('file[@href="i05a5b1468af5e9257a2f6b0827a0bd96.xml"]').first
    assert file

    assert get_imscc_file('if7091ac80f57e45c757345555327b248.xml') # topic xml
    assert get_imscc_file('i05a5b1468af5e9257a2f6b0827a0bd96.xml') # topic meta xml
  end

  def test_it_creates_item_in_module_meta
    discussion_topic = Moodle2CC::Canvas::DiscussionTopic.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(discussion_topic.create_module_meta_item_node(node, 5))

    assert_equal 'item', xml.root.name
    assert_equal 'ie8e11ad7a1b32660f6aeaf94948faa22', xml.root.attributes['identifier'].value
    assert_equal "Announcements", xml.root.xpath('title').text
    assert_equal '5', xml.root.xpath('position').text
    assert_equal '', xml.root.xpath('new_tab').text
    assert_equal '0', xml.root.xpath('indent').text
    assert_equal 'DiscussionTopic', xml.root.xpath('content_type').text
    assert_equal 'if7091ac80f57e45c757345555327b248', xml.root.xpath('identifierref').text
  end

  def test_it_create_topic_xml
    @mod.name = "Announcements"
    @mod.intro = "<h1>Hello World</h1>"

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    discussion_topic = Moodle2CC::Canvas::DiscussionTopic.new @mod
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

  def test_it_create_topic_meta_xml
    @mod.name = "Announcements"
    @mod.section_mod.added = 1340731824

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    discussion_topic = Moodle2CC::Canvas::DiscussionTopic.new @mod
    discussion_topic.create_topic_meta_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, "#{discussion_topic.identifierref}.xml")))

    assert xml
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0", xml.namespaces['xmlns']
    assert_equal discussion_topic.identifierref, xml.xpath('xmlns:topicMeta').first.attributes['identifier'].value

    assert_equal discussion_topic.identifier, xml.search('topic_id').text
    assert_equal 'Announcements', xml.search('title').text
    assert_equal '2012-06-26T17:30:24', xml.search('posted_at').text
    assert_equal '0', xml.search('position').text
    assert_equal 'topic', xml.search('type').text
  end
end
