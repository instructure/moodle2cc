require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCWebContent < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |m| m.mod_type == "resource" && m.type == "html" }
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @mod.id = 543

    web_content = Moodle2CC::CC::WebContent.new @mod
    assert_equal 543, web_content.id
  end

  def test_it_converts_title
    @mod.name = "Instructor Resources"

    web_content = Moodle2CC::CC::WebContent.new @mod
    assert_equal "Instructor Resources", web_content.title
  end

  def test_it_converts_body
    @mod.alltext = %(<h1>Hello World</h1><img src="$@FILEPHP@$$@SLASH@$folder$@SLASH@$stuff.jpg" />)

    web_content = Moodle2CC::CC::WebContent.new @mod
    assert_equal %(<h1>Hello World</h1><img src="$IMS_CC_FILEBASE$/folder/stuff.jpg" />), web_content.body
  end

  def test_it_has_an_identifier
    @mod.id = 543

    web_content = Moodle2CC::CC::WebContent.new @mod
    assert_equal 'i6447ff05ab6e342a42302007a6e3bcb4', web_content.identifier
  end

  def test_it_creates_resource_in_imsmanifest
    web_content = Moodle2CC::CC::WebContent.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(web_content.create_resource_node(node))

    resource = xml.xpath('resource').first
    assert resource
    assert_equal 'webcontent', resource.attributes['type'].value
    assert_equal 'i6447ff05ab6e342a42302007a6e3bcb4', resource.attributes['identifier'].value
    assert_equal Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER + '/instructor-resources.html', resource.attributes['href'].value

    file = resource.xpath(%{file[@href="#{Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER}/instructor-resources.html"]}).first
    assert file
  end

  def test_it_creates_html
    @mod.id = 543
    @mod.name = "Instructor Resources"
    @mod.alltext = "<p><strong>Instructor Resources</strong></p>"

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    web_content = Moodle2CC::CC::WebContent.new @mod
    web_content.create_html(tmp_dir)
    html = Nokogiri::HTML(File.read(File.join(tmp_dir, Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER, 'instructor-resources.html')))

    assert html
    assert_equal 'i6447ff05ab6e342a42302007a6e3bcb4', html.search('head meta[name="identifier"]').first.attributes['content'].value
    assert_equal "Instructor Resources", html.search('title').text
    assert_equal "<p><strong>Instructor Resources</strong></p>", html.search('body').inner_html.strip
  end
end
