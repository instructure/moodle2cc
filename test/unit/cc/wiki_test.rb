require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'test/test_wiki_helper'
require 'moodle2cc'

class TestUnitCCWiki < MiniTest::Unit::TestCase
  include TestHelper
  include TestWikiHelper

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

  def test_it_converts_pages
    pages!
    wiki = Moodle2CC::CC::Wiki.new @mod
    assert_equal 2, wiki.pages.length

    assert_equal 'My Wiki', wiki.pages[0].title
    assert_equal 'Second version', wiki.pages[0].body
    assert_equal Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER + '/my-wiki-my-wiki.html', wiki.pages[0].href
    assert_equal 'i2eb0de275c9d8430f49bbf4cdf96286c', wiki.pages[0].identifier

    assert_equal 'New Page', wiki.pages[1].title
    assert_equal 'This is a link to [My Wiki]', wiki.pages[1].body
    assert_equal Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER + '/my-wiki-new-page.html', wiki.pages[1].href
    assert_equal 'i2eb0de275c9d8430f49bbf4cdf96286c', wiki.pages[0].identifier
  end

  def test_it_converts_summary_to_page_if_no_pages_exist
    @mod.page_name = 'My Wiki'
    @mod.summary = 'This is the summary'
    @mod.pages = []

    wiki = Moodle2CC::CC::Wiki.new @mod
    assert_equal 1, wiki.pages.length

    assert_equal 'My wiki', wiki.pages[0].title
    assert_equal 'This is the summary', wiki.pages[0].body
    assert_equal Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER + '/my-wiki.html', wiki.pages[0].href
    assert_equal 'ib1bfc2398c654e88470adb5a882f83e5', wiki.pages[0].identifier
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
    assert_equal 'ib1bfc2398c654e88470adb5a882f83e5', wiki.identifier
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
    assert_equal Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER + '/my-wiki-link.html', resource.attributes['href'].value
    assert_equal 'ie8b2c8b5a9156a6994b13abae6b18da6', resource.attributes['identifier'].value

    file = resource.xpath(%{file[@href="#{Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER}/my-wiki-link.html"]}).first
    assert file

    resource = xml.root.xpath('resource[2]').first
    assert resource
    assert_equal 'webcontent', resource.attributes['type'].value
    assert_equal Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER + '/my-wiki-my-wiki.html', resource.attributes['href'].value
    assert_equal 'i2eb0de275c9d8430f49bbf4cdf96286c', resource.attributes['identifier'].value

    file = resource.xpath(%{file[@href="#{Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER}/my-wiki-my-wiki.html"]}).first
    assert file
  end

  def test_it_creates_wiki_html
    wiki = Moodle2CC::CC::Wiki.new @mod
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    wiki.create_html(tmp_dir)

    html = Nokogiri::HTML(File.read(File.join(tmp_dir, Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER + '/my-wiki-my-wiki.html')))
    assert html
    assert_equal 'i2eb0de275c9d8430f49bbf4cdf96286c', html.search('meta[name="identifier"]').first.attributes['content'].value
    assert_equal 'My Wiki', html.search('title').text
    assert_equal 'Hello [link]', html.search('body').inner_html.strip

    html = Nokogiri::HTML(File.read(File.join(tmp_dir, Moodle2CC::CC::CCHelper::CC_WIKI_FOLDER + '/my-wiki-link.html')))
    assert html
    assert_equal 'ie8b2c8b5a9156a6994b13abae6b18da6', html.search('meta[name="identifier"]').first.attributes['content'].value
    assert_equal 'link', html.search('title').text
    assert_equal 'This is a linked page', html.search('body').inner_html.strip
  end
end
