require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCCCourse < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup
    @course = @backup.course
    @cc_course = Moodle2CC::CC::Course.new @course
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_converts_id
    assert_equal 55555, @cc_course.id
  end

  def test_it_converts_title
    assert_equal 'My Course', @cc_course.title
  end

  def test_it_converts_course_code
    assert_equal 'EDU 101', @cc_course.course_code
  end

  def test_it_converts_start_at
    assert_equal '2012-06-11T05:00:00', @cc_course.start_at
  end

  def test_it_converts_is_public
    assert_equal true, @cc_course.is_public
  end

  def test_it_converts_syllabus_body
    assert_equal '<h1>This is the Syllabus</h1>', @cc_course.syllabus_body
  end

  def test_it_creates_resource_in_imsmanifest
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(@cc_course.create_resources_node(node))

    resource = xml.xpath('resource').first
    assert resource
    assert_equal 'syllabus', resource.attributes['intendeduse'].value
    assert_equal 'course_settings/syllabus.html', resource.attributes['href'].value
    assert_equal 'associatedcontent/imscc_xmlv1p1/learning-application-resource', resource.attributes['type'].value
    assert_equal 'i056ad8a52e3d89b15c15c97434aa0e91', resource.attributes['identifier'].value

    # syllabus
    assert resource.xpath('file[@href="course_settings/syllabus.html"]').first
    assert get_imscc_file('course_settings/syllabus.html')

    # course settings
    assert resource.xpath('file[@href="course_settings/course_settings.xml"]').first
    assert get_imscc_file('course_settings/course_settings.xml')

    # files meta
    assert resource.xpath('file[@href="course_settings/files_meta.xml"]').first
    assert get_imscc_file('course_settings/files_meta.xml')

    # module meta
    assert resource.xpath('file[@href="course_settings/module_meta.xml"]').first
    assert get_imscc_file('course_settings/module_meta.xml')

    # assignment groups
    assert resource.xpath('file[@href="course_settings/assignment_groups.xml"]').first
    assert get_imscc_file('course_settings/assignment_groups.xml')

    # web resources
    assert get_imscc_file('web_resources/folder/test.txt')
    assert get_imscc_file('web_resources/test.txt')
  end

  def test_it_creates_syllabus_file
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    @cc_course.create_syllabus_file(tmp_dir)
    html = Nokogiri::HTML(File.read(File.join(tmp_dir, 'course_settings', 'syllabus.html')))

    assert html
    assert_equal 'Syllabus', html.search('title').text
  end

  def test_it_create_course_settings_xml
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    @cc_course.create_course_settings_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, 'course_settings', 'course_settings.xml')))

    assert xml
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0", xml.namespaces['xmlns']
    assert_equal @cc_course.identifier, xml.xpath('xmlns:course').first.attributes['identifier'].value

    assert_equal @course.fullname, xml.search('title').text
    assert_equal @course.shortname, xml.search('course_code').text
    assert_equal '2012-06-11T05:00:00', xml.search('start_at').text
    assert_equal 'true', xml.search('is_public').text
    assert_equal 'private', xml.search('license').text
  end

  def test_it_creates_module_meta_xml
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    @cc_course.create_module_meta_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, 'course_settings', 'module_meta.xml')))

    assert xml
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0", xml.namespaces['xmlns']

    assert_equal 'iebbd12be3d1d1ba16e241599099c4795', xml.xpath('//xmlns:modules/xmlns:module').first.attributes['identifier'].value

    assert xml.xpath('//xmlns:modules/xmlns:module').count == 2

    first_module = xml.xpath('//xmlns:modules/xmlns:module').first
    assert_equal 'week 0', first_module.xpath('xmlns:title').text
    assert_equal '0', first_module.xpath('xmlns:position').text
    assert_equal 'false', first_module.xpath('xmlns:require_sequential_progress').text
    assert_equal 1, first_module.xpath('xmlns:items').first.xpath('xmlns:item').count

    item_node = first_module.xpath('xmlns:items').first.xpath('xmlns:item').first
    assert_equal 'ExternalUrl', item_node.xpath('xmlns:content_type').text
    assert_equal 'About Your Instructor', item_node.xpath('xmlns:title').text
    assert_equal '1', item_node.xpath('xmlns:position').text
    assert_equal '', item_node.xpath('xmlns:new_tab').text
    assert_equal '1', item_node.xpath('xmlns:indent').text
    assert_equal 'http://en.wikipedia.org/wiki/Einstein', item_node.xpath('xmlns:url').text
    assert_equal 'ibd69090f0854ccc9bc06276117c9fffd', item_node.xpath('xmlns:identifierref').text
  end

  def test_it_creates_assignment_groups_xml
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    @cc_course.create_assignment_groups_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, 'course_settings', 'assignment_groups.xml')))

    assert xml
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0", xml.namespaces['xmlns']

    assert_equal 1, xml.xpath('//xmlns:assignmentGroups/xmlns:assignmentGroup').count

    assignment_group = xml.xpath('//xmlns:assignmentGroups/xmlns:assignmentGroup[1]').first
    assert_equal 'i521ff0228432bb106b9535e8c5139df3', assignment_group.attributes['identifier'].value
    assert_equal 'Week 0', assignment_group.xpath('xmlns:title').text
  end

  def test_it_creates_files_meta_xml
    tmp_dir = File.expand_path('../../../tmp', __FILE__)
    @cc_course.create_files_meta_xml(tmp_dir)
    xml = Nokogiri::XML(File.read(File.join(tmp_dir, 'course_settings', 'files_meta.xml')))

    assert xml
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://canvas.instructure.com/xsd/cccv1p0", xml.namespaces['xmlns']

    assert_equal 1, xml.xpath('//xmlns:filesMeta').count
  end

end
