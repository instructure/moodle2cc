require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCAssignment < MiniTest::Unit::TestCase
  include TestHelper

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 123

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 123, assignment.id
  end

  def test_it_converts_title
    mod = Moodle2CC::Moodle::Mod.new
    mod.name = "Create a Rails site"

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal "Create a Rails site", assignment.title
  end

  def test_it_converts_body
    mod = Moodle2CC::Moodle::Mod.new
    mod.description = "<h1>Hello World</h1>"

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal "<h1>Hello World</h1>", assignment.body
  end

  # def test_it_converts_assignment_group_identifier_ref
    # mod = Moodle2CC::Moodle::Mod.new
    # assignment = Moodle2CC::CC::Assignment.new mod
  # end

  def test_it_converts_points_possible
    mod = Moodle2CC::Moodle::Mod.new
    mod.grade = 5

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 5, assignment.points_possible
  end

  def test_it_converts_grading_type
    mod = Moodle2CC::Moodle::Mod.new

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 'points', assignment.grading_type
  end

  def test_it_converts_due_at
    mod = Moodle2CC::Moodle::Mod.new
    mod.time_due = Time.parse("2012/12/12 12:12:12 +0000").to_i

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal '2012-12-12T12:12:12', assignment.due_at
  end

  def test_it_converts_unlock_at
    mod = Moodle2CC::Moodle::Mod.new
    mod.time_available = Time.parse("2012/12/12 12:12:12 +0000").to_i

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal '2012-12-12T12:12:12', assignment.unlock_at
  end

  def test_it_converts_lock_at
    mod = Moodle2CC::Moodle::Mod.new
    mod.time_due = Time.parse("2012/12/12 12:12:12 +0000").to_i
    mod.prevent_late = false

    assignment = Moodle2CC::CC::Assignment.new mod
    refute assignment.lock_at

    mod.prevent_late = true

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal '2012-12-12T12:12:12', assignment.lock_at
  end

  def test_it_converts_all_day
    mod = Moodle2CC::Moodle::Mod.new
    mod.time_due = Time.parse("2012/12/12 23:58:00 +0000").to_i

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal false, assignment.all_day

    mod = Moodle2CC::Moodle::Mod.new
    mod.time_due = Time.parse("2012/12/12 23:59:00 +0000").to_i

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal true, assignment.all_day
  end

  def test_it_converts_all_day_date
    mod = Moodle2CC::Moodle::Mod.new
    mod.time_due = Time.parse("2012/12/12 23:59:00 +0000").to_i

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal '2012-12-12', assignment.all_day_date
  end

  def test_it_converts_submission_types
    mod = Moodle2CC::Moodle::Mod.new
    mod.assignment_type = 'offline'
    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 'none', assignment.submission_types

    mod = Moodle2CC::Moodle::Mod.new
    mod.assignment_type = 'online'
    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 'online_text_entry', assignment.submission_types

    mod = Moodle2CC::Moodle::Mod.new
    mod.assignment_type = 'upload'
    mod.var2 = 0
    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 'online_upload', assignment.submission_types

    mod = Moodle2CC::Moodle::Mod.new
    mod.assignment_type = 'upload'
    mod.var2 = 1
    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 'online_upload,online_text_entry', assignment.submission_types

    mod = Moodle2CC::Moodle::Mod.new
    mod.assignment_type = 'uploadsingle'
    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 'online_upload', assignment.submission_types
  end

  def test_it_has_an_identifier
    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 123

    assignment = Moodle2CC::CC::Assignment.new mod
    assert_equal 'i802fea43604b8e56736e233ae2ca2ee9', assignment.identifier
  end

  def test_it_creates_assignment_html
    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 123
    mod.name = "Create a Rails site"
    mod.description = "<h1>Hello World</h1>"

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    assignment = Moodle2CC::CC::Assignment.new mod
    assignment.create_html(tmp_dir)
    html = Nokogiri::HTML(File.read(File.join(tmp_dir, assignment.identifier, 'create-a-rails-site.html')))

    assert html
    assert_equal 'Assignment: Create a Rails site', html.search('title').text
    assert_equal '<h1>Hello World</h1>', html.search('body').inner_html.strip
  end

  def test_it_creates_assignment_settings_file
    mod = Moodle2CC::Moodle::Mod.new
    mod.id = 123
    mod.name = "Create a Rails site"
    mod.description = "<h1>Hello World</h1>"
    mod.grade = 5
    mod.time_due = Time.parse("2012/12/12 23:59:00 +0000").to_i
    mod.time_available = Time.parse("2012/12/12 12:12:12 +0000").to_i
    mod.prevent_late = true
    mod.assignment_type = 'offline'

    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    assignment = Moodle2CC::CC::Assignment.new mod, 9
    assignment.create_settings_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, assignment.identifier, 'assignment_settings.xml')))

    assert xml
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0", xml.namespaces['xmlns']
    assert_equal assignment.identifier, xml.xpath('xmlns:assignment').first.attributes['identifier'].value

    assert_equal 'Create a Rails site', xml.xpath('xmlns:assignment/xmlns:title').text
    # assert_equal '', xml.xpath('xmlns:assignment/xmlns:assignment_group_identifierref').text
    assert_equal '5', xml.xpath('xmlns:assignment/xmlns:points_possible').text
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
