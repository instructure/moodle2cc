require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCanvasAssignment < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup('canvas')
    @mod = @backup.course.mods.find { |m| m.mod_type == "assignment" }
    @workshop_mod = @backup.course.mods.find { |m| m.mod_type == "workshop" }
    @assignment = Moodle2CC::Canvas::Assignment.new @mod
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_inherits_from_cc
    assert Moodle2CC::Canvas::Assignment.ancestors.include?(Moodle2CC::CC::Assignment), 'does not inherit from base CC class'
  end

  def test_it_converts_assignment_group_identifierref
    @mod.section_mod.section.id = 987
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal 'ie9418dcb7e475d6f4676915b0e72f0c7', assignment.assignment_group_identifierref
  end

  def test_it_converts_points_possible
    grade_item = @mod.grade_item
    grade_item.grade_max = 187
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal 187, assignment.points_possible
  end

  def test_it_converts_grading_type
    assert_equal 'points', @assignment.grading_type
  end

  def test_it_converts_due_at
    @mod.time_due = Time.parse("2012/12/12 12:12:12 +0000").to_i
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal '2012-12-12T12:12:12', assignment.due_at
  end

  def test_it_converts_due_at_from_submission_end_time
    @workshop_mod.submission_end = Time.parse("2009/09/09 09:09:09 +0000").to_i
    assignment = Moodle2CC::Canvas::Assignment.new @workshop_mod
    assert_equal '2009-09-09T09:09:09', assignment.due_at
  end

  def test_it_converts_unlock_at
    @mod.time_available = Time.parse("2012/12/12 12:12:12 +0000").to_i
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal '2012-12-12T12:12:12', assignment.unlock_at
  end

  def test_it_converts_lock_at
    @mod.time_due = Time.parse("2012/12/12 12:12:12 +0000").to_i
    @mod.prevent_late = false

    assignment = Moodle2CC::Canvas::Assignment.new @mod
    refute assignment.lock_at

    @mod.prevent_late = true

    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal '2012-12-12T12:12:12', assignment.lock_at
  end

  def test_it_converts_all_day
    @mod.time_due = Time.parse("2012/12/12 23:58:00 +0000").to_i

    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal false, assignment.all_day

    @mod.time_due = Time.parse("2012/12/12 23:59:00 +0000").to_i

    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal true, assignment.all_day
  end

  def test_it_converts_all_day_date
    @mod.time_due = Time.parse("2012/12/12 23:59:00 +0000").to_i

    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal '2012-12-12', assignment.all_day_date
  end

  def test_it_converts_submission_types
    @mod.assignment_type = 'offline'
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal 'none', assignment.submission_types

    @mod.assignment_type = 'online'
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal 'online_text_entry', assignment.submission_types

    @mod.assignment_type = 'upload'
    @mod.var2 = 0
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal 'online_upload', assignment.submission_types

    @mod.assignment_type = 'upload'
    @mod.var2 = 1
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal 'online_upload,online_text_entry', assignment.submission_types

    @mod.assignment_type = 'uploadsingle'
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal 'online_upload', assignment.submission_types

    @workshop_mod.number_of_attachments = 0
    assignment = Moodle2CC::Canvas::Assignment.new @workshop_mod
    assert_equal 'online_text_entry', assignment.submission_types

    @workshop_mod.number_of_attachments = 1
    assignment = Moodle2CC::Canvas::Assignment.new @workshop_mod
    assert_equal 'online_upload,online_text_entry', assignment.submission_types
  end

  def test_it_converts_peer_reviews
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal false, assignment.peer_reviews

    assignment = Moodle2CC::Canvas::Assignment.new @workshop_mod
    assert_equal true, assignment.peer_reviews
  end

  def test_it_converts_automatic_peer_reviews
    assignment = Moodle2CC::Canvas::Assignment.new @mod
    assert_equal false, assignment.automatic_peer_reviews

    assignment = Moodle2CC::Canvas::Assignment.new @workshop_mod
    assert_equal true, assignment.automatic_peer_reviews
  end

  def test_it_converts_peer_review_count
    @workshop_mod.number_of_student_assessments = 5
    assignment = Moodle2CC::Canvas::Assignment.new @workshop_mod
    assert_equal 5, assignment.peer_review_count
  end

  def test_it_converts_anonymous_peer_review
    @workshop_mod.anonymous = true
    assignment = Moodle2CC::Canvas::Assignment.new @workshop_mod
    assert_equal true, assignment.anonymous_peer_reviews

    @workshop_mod.anonymous = false
    assignment = Moodle2CC::Canvas::Assignment.new @workshop_mod
    assert_equal false, assignment.anonymous_peer_reviews
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

    file = resource.xpath('file[@href="i6b162484accdf6081cea43b39219d129/assignment_settings.xml"]').first
    assert file
  end

  def test_it_creates_item_in_module_meta
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(@assignment.create_module_meta_item_node(node, 5))

    assert_equal 'item', xml.root.name
    assert_equal 'i10241816e5909d8e76da003b2814c6a4', xml.root.attributes['identifier'].value
    assert_equal 'Create a Rails site', xml.root.xpath('title').text
    assert_equal '5', xml.root.xpath('position').text
    assert_equal '', xml.root.xpath('new_tab').text
    assert_equal '0', xml.root.xpath('indent').text
    assert_equal 'Assignment', xml.root.xpath('content_type').text
    assert_equal 'i6b162484accdf6081cea43b39219d129', xml.root.xpath('identifierref').text
  end

  def test_it_creates_assignment_html
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    @assignment.create_html(tmp_dir)
    html = Nokogiri::HTML(File.read(File.join(tmp_dir, @assignment.identifier, 'create-a-rails-site.html')))

    assert html
    assert_equal 'Assignment: Create a Rails site', html.search('title').text
    assert_equal '<h1>Hello World</h1>', html.search('body').inner_html.strip
  end

  def test_it_creates_assignment_settings_file
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    @assignment.position = 9
    @assignment.create_settings_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, @assignment.identifier, 'assignment_settings.xml')))

    assert xml
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0", xml.namespaces['xmlns']
    assert_equal @assignment.identifier, xml.xpath('xmlns:assignment').first.attributes['identifier'].value

    assert_equal 'Create a Rails site', xml.xpath('xmlns:assignment/xmlns:title').text
    assert_equal 'i521ff0228432bb106b9535e8c5139df3', xml.xpath('xmlns:assignment/xmlns:assignment_group_identifierref').text
    assert_equal '150.0', xml.xpath('xmlns:assignment/xmlns:points_possible').text
    assert_equal 'points', xml.xpath('xmlns:assignment/xmlns:grading_type').text
    assert_equal 'true', xml.xpath('xmlns:assignment/xmlns:all_day').text
    assert_equal 'none', xml.xpath('xmlns:assignment/xmlns:submission_types').text
    assert_equal '9', xml.xpath('xmlns:assignment/xmlns:position').text
    assert_equal '2012-12-12T23:59:00', xml.xpath('xmlns:assignment/xmlns:due_at').text
    assert_equal '2012-12-12', xml.xpath('xmlns:assignment/xmlns:all_day_date').text
    assert_equal '2012-12-12T23:59:00', xml.xpath('xmlns:assignment/xmlns:lock_at').text
    assert_equal '2012-12-12T12:12:12', xml.xpath('xmlns:assignment/xmlns:unlock_at').text
  end
end
