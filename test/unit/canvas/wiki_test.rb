require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'test/test_wiki_helper'
require 'moodle2cc'

class TestUnitCanvasWiki < MiniTest::Unit::TestCase
  include TestHelper
  include TestWikiHelper

  def setup
    convert_moodle_backup 'canvas'
    @mod = @backup.course.mods.find { |m| m.mod_type == "wiki" }
    @wiki = Moodle2CC::Canvas::Wiki.new @mod
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_inherits_from_cc
    assert Moodle2CC::Canvas::Wiki.ancestors.include?(Moodle2CC::CC::Wiki), 'does not inherit from base CC class'
  end

  def test_it_converts_pages
    pages!
    wiki = Moodle2CC::Canvas::Wiki.new @mod
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


  def test_it_creates_item_in_module_meta
    wiki = Moodle2CC::Canvas::Wiki.new @mod
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(wiki.create_module_meta_item_node(node, 5))

    assert_equal 'item', xml.root.name
    assert_equal 'i7b382ae83ddb7cc9be1a12e517088bc4', xml.root.attributes['identifier'].value
    assert_equal "My wiki", xml.root.xpath('title').text
    assert_equal '5', xml.root.xpath('position').text
    assert_equal '', xml.root.xpath('new_tab').text
    assert_equal '0', xml.root.xpath('indent').text
    assert_equal 'WikiPage', xml.root.xpath('content_type').text
    assert_equal 'i56eb35e2b44710c48f7aa6b6297e9c98', xml.root.xpath('identifierref').text
  end

  def test_it_creates_wiki_html
    wiki = Moodle2CC::Canvas::Wiki.new @mod
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
