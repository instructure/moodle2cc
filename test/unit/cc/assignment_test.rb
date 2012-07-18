require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCAssignment < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @mod = @backup.course.mods.find { |m| m.mod_type == "assignment" }
    @workshop_mod = @backup.course.mods.find { |m| m.mod_type == "workshop" }
    @assignment = Moodle2CC::CC::Assignment.new @mod
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    @mod.id = 987
    assignment = Moodle2CC::CC::Assignment.new @mod
    assert_equal 987, assignment.id
  end

  def test_it_converts_title
    @mod.name = "Create a Rails site"
    assignment = Moodle2CC::CC::Assignment.new @mod
    assert_equal "Create a Rails site", assignment.title
  end

  def test_it_converts_body
    @mod.description = %(<h1>Hello World</h1><img src="$@FILEPHP@$$@SLASH@$folder$@SLASH@$stuff.jpg" />)
    assignment = Moodle2CC::CC::Assignment.new @mod
    assert_equal %(<h1>Hello World</h1><img src="$IMS_CC_FILEBASE$/folder/stuff.jpg" />), assignment.body
  end

  def test_it_has_an_identifier
    @mod.id = 987
    assignment = Moodle2CC::CC::Assignment.new @mod
    assert_equal 'i6b162484accdf6081cea43b39219d129', assignment.identifier
  end

  def test_it_creates_resource_in_imsmanifest
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(@assignment.create_resource_node(node))

    resource = xml.xpath('resource').first
    assert resource
    assert_equal 'associatedcontent/imscc_xmlv1p1/learning-application-resource', resource.attributes['type'].value
    assert_equal 'i6b162484accdf6081cea43b39219d129/create-a-rails-site.html', resource.attributes['href'].value
    assert_equal 'i6b162484accdf6081cea43b39219d129', resource.attributes['identifier'].value

    file = resource.xpath('file[@href="i6b162484accdf6081cea43b39219d129/create-a-rails-site.html"]').first
    assert file
  end

  def test_it_creates_assignment_html
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    @assignment.create_html(tmp_dir)
    html = Nokogiri::HTML(File.read(File.join(tmp_dir, @assignment.identifier, 'create-a-rails-site.html')))

    assert html
    assert_equal 'Assignment: Create a Rails site', html.search('title').text
    assert_equal '<h1>Hello World</h1>', html.search('body').inner_html.strip
  end
end
