require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCWiki < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |m| m.mod_type == "wiki" }
    @wiki = Moodle2CC::CC::Wiki.new @mod
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @mod.id = 210
    wiki = Moodle2CC::CC::Wiki.new @mod
    assert_equal 210, wiki.id
  end

  def test_it_converts_title
    @mod.name = 'My Wiki'
    wiki = Moodle2CC::CC::Wiki.new @mod
    assert_equal 'My Wiki', wiki.title
  end

  def test_it_converts_page_name
    @mod.name = 'My Wiki'
    wiki = Moodle2CC::CC::Wiki.new @mod
    assert_equal 'My Wiki', wiki.title
  end

  def pages!
    @page1 = Moodle2CC::Moodle::Mod::Page.new
    @page1.page_name = 'My Wiki'
    @page1.version = 1
    @page1.content = 'First version'

    @page2 = Moodle2CC::Moodle::Mod::Page.new
    @page2.page_name = 'My Wiki'
    @page2.version = 2
    @page2.content = 'Second version'

    @page3 = Moodle2CC::Moodle::Mod::Page.new
    @page3.page_name = 'New Page'
    @page3.version = 1
    @page3.content = 'This is a link to [My Wiki]'

    @mod.page_name = 'My Wiki'
    @mod.pages = [@page1, @page2, @page3]
  end

  def test_it_converts_pages
    pages!
    wiki = Moodle2CC::CC::Wiki.new @mod
    assert_equal 2, wiki.pages.length

    assert_equal 'My Wiki', wiki.pages[0].title
    assert_equal 'Second version', wiki.pages[0].body
    assert_equal 'wiki_content/my-wiki-my-wiki.html', wiki.pages[0].href
    assert_equal 'i56eb35e2b44710c48f7aa6b6297e9c98', wiki.pages[0].identifier

    assert_equal 'New Page', wiki.pages[1].title
    assert_equal 'This is a link to <a href="%24WIKI_REFERENCE%24/wiki/my-wiki-my-wiki" title="My Wiki">My Wiki</a>', wiki.pages[1].body
    assert_equal 'wiki_content/my-wiki-new-page.html', wiki.pages[1].href
    assert_equal 'i56eb35e2b44710c48f7aa6b6297e9c98', wiki.pages[0].identifier
  end

  def test_it_converts_summary_to_page_if_no_pages_exist
    @mod.page_name = 'My Wiki'
    @mod.summary = 'This is the summary'
    @mod.pages = []

    wiki = Moodle2CC::CC::Wiki.new @mod
    assert_equal 1, wiki.pages.length

    assert_equal 'My Wiki', wiki.pages[0].title
    assert_equal 'This is the summary', wiki.pages[0].body
    assert_equal 'wiki_content/my-wiki.html', wiki.pages[0].href
    assert_equal 'ib87fd4bafae6f3e3ee7dadb65b0e45a3', wiki.pages[0].identifier
  end

  def test_it_has_a_root_page_for_defined_pages
    pages!
    wiki = Moodle2CC::CC::Wiki.new @mod
    page = wiki.pages.find { |page| page.title == 'My Wiki' }
    assert_equal page, wiki.root_page
  end

  def test_it_has_a_root_page_for_summary
    @mod.page_name = 'My Wiki'
    @mod.summary = 'This is the summary'
    @mod.pages = []

    wiki = Moodle2CC::CC::Wiki.new @mod
    page = wiki.pages.first
    assert_equal page, wiki.root_page
  end

  def test_it_has_a_identifier_for_root_page
    @mod.page_name = 'My Wiki'
    @mod.summary = 'This is the summary'
    @mod.pages = []

    wiki = Moodle2CC::CC::Wiki.new @mod
    assert_equal 'ib87fd4bafae6f3e3ee7dadb65b0e45a3', wiki.identifier
  end

  def test_it_creates_resource_in_imsmanifest
    wiki = Moodle2CC::CC::Wiki.new @mod
    node = Builder::XmlMarkup.new
    xml = node.root do |root_node|
      wiki.create_resource_node(node)
    end
    xml = Nokogiri::XML(xml)

    resource = xml.root.xpath('resource[1]').first
    assert resource
    assert_equal 'webcontent', resource.attributes['type'].value
    assert_equal 'wiki_content/my-wiki-link.html', resource.attributes['href'].value
    assert_equal 'i13d1eba598141a33bd00dc38186d148a', resource.attributes['identifier'].value

    file = resource.xpath('file[@href="wiki_content/my-wiki-link.html"]').first
    assert file

    resource = xml.root.xpath('resource[2]').first
    assert resource
    assert_equal 'webcontent', resource.attributes['type'].value
    assert_equal 'wiki_content/my-wiki-my-wiki.html', resource.attributes['href'].value
    assert_equal 'i56eb35e2b44710c48f7aa6b6297e9c98', resource.attributes['identifier'].value

    file = resource.xpath('file[@href="wiki_content/my-wiki-my-wiki.html"]').first
    assert file
  end

  def test_it_creates_item_in_module_meta
    wiki = Moodle2CC::CC::Wiki.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(wiki.create_module_meta_item_node(node, 5))

    assert_equal 'item', xml.root.name
    assert_equal 'i7b382ae83ddb7cc9be1a12e517088bc4', xml.root.attributes['identifier'].value
    assert_equal "My Wiki", xml.root.xpath('title').text
    assert_equal '5', xml.root.xpath('position').text
    assert_equal '', xml.root.xpath('new_tab').text
    assert_equal '0', xml.root.xpath('indent').text
    assert_equal 'WikiPage', xml.root.xpath('content_type').text
    assert_equal 'i56eb35e2b44710c48f7aa6b6297e9c98', xml.root.xpath('identifierref').text
  end

  def test_it_creates_wiki_html
    wiki = Moodle2CC::CC::Wiki.new @mod
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    wiki.create_html(tmp_dir)

    html = Nokogiri::HTML(File.read(File.join(tmp_dir, 'wiki_content/my-wiki-my-wiki.html')))
    assert html
    assert_equal 'i56eb35e2b44710c48f7aa6b6297e9c98', html.search('meta[name="identifier"]').first.attributes['content'].value
    assert_equal 'My Wiki', html.search('title').text
    assert_equal 'Hello <a href="%24WIKI_REFERENCE%24/wiki/my-wiki-link" title="link">link</a>', html.search('body').inner_html.strip

    html = Nokogiri::HTML(File.read(File.join(tmp_dir, 'wiki_content/my-wiki-link.html')))
    assert html
    assert_equal 'i13d1eba598141a33bd00dc38186d148a', html.search('meta[name="identifier"]').first.attributes['content'].value
    assert_equal 'link', html.search('title').text
    assert_equal 'This is a linked page', html.search('body').inner_html.strip
  end
end
