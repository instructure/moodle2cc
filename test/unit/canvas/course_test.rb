require 'nokogiri'
require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'

class TestUnitCanvasCourse < MiniTest::Unit::TestCase
  include TestHelper

  def setup
    convert_moodle_backup('canvas')
    @course = @backup.course
    @cc_course = Moodle2CC::Canvas::Course.new @course
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_inherits_from_cc
    assert Moodle2CC::Canvas::Course.ancestors.include?(Moodle2CC::CC::Course), 'does not inherit from base CC class'
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
    section = Moodle2CC::Moodle::Section.new
    section.summary = %(<h1>Hello World</h1><img src="$@FILEPHP@$$@SLASH@$folder$@SLASH@$stuff.jpg" />)
    @course.sections = [section]
    cc_course = Moodle2CC::Canvas::Course.new @course
    assert_equal %(<h1>Hello World</h1><img src="$IMS_CC_FILEBASE$/folder/stuff.jpg" />), cc_course.syllabus_body
  end

  def test_it_creates_resource_in_imsmanifest
    node = Builder::XmlMarkup.new
    xml = Nokogiri::XML(@cc_course.create_resource_node(node))

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

    assert_equal 3, xml.xpath('//xmlns:modules/xmlns:module').count

    module_node = xml.xpath('//xmlns:modules/xmlns:module[1]').first
    assert_equal 'Week 0', module_node.xpath('xmlns:title').text
    assert_equal '0', module_node.xpath('xmlns:position').text
    assert_equal 'false', module_node.xpath('xmlns:require_sequential_progress').text
    assert_equal 3, module_node.xpath('xmlns:items').first.xpath('xmlns:item').count

    module_node = xml.xpath('//xmlns:modules/xmlns:module[2]').first
    assert_equal 'Week 1', module_node.xpath('xmlns:title').text
    assert_equal '1', module_node.xpath('xmlns:position').text
    assert_equal 'false', module_node.xpath('xmlns:require_sequential_progress').text
    assert_equal 9, module_node.xpath('xmlns:items').first.xpath('xmlns:item').count

    module_node = xml.xpath('//xmlns:modules/xmlns:module[3]').first
    assert_equal 'Week 3', module_node.xpath('xmlns:title').text
    assert_equal '3', module_node.xpath('xmlns:position').text
    assert_equal 'false', module_node.xpath('xmlns:require_sequential_progress').text
    assert_equal 2, module_node.xpath('xmlns:items').first.xpath('xmlns:item').count
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
