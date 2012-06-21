require 'minitest/autorun'
require 'test/test_helper'
require 'moodle2cc'
require 'nokogiri'

class TestUnitCCConverter < MiniTest::Unit::TestCase
  include TestHelper
  def setup
    stub_moodle_backup
  end

  def teardown
    clean_tmp_folder
  end

  def get_imsmanifest_xml
    Zip::ZipFile.open(@converter.imscc_path) do |zipfile|
      xml = Nokogiri::XML(zipfile.read("imsmanifest.xml"))
    end
  end

  def test_it_has_the_path_to_the_imscc_package
    assert_equal File.expand_path("../../../tmp/my_course.imscc", __FILE__), @converter.imscc_path
  end

  def test_it_creates_imscc_package
    assert File.exists?(@converter.imscc_path)
  end

  def test_it_creates_imsmanifest_xml
    Zip::ZipFile.open(@converter.imscc_path) do |zipfile|
      assert zipfile.find_entry("imsmanifest.xml")
    end
  end

  def test_imsmanifest_has_manifest_root
    xml = get_imsmanifest_xml
    assert_equal "manifest", xml.root.name
    assert_equal "i169d3646de97621daf8cdd49878a95dc", xml.root.attributes['identifier'].value
  end

  def test_imsmanifest_has_proper_namespaces
    xml = get_imsmanifest_xml
    assert_equal "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imscp_v1p2_v1p0.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lomresource_v1p0.xsd http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest http://www.imsglobal.org/profile/cc/ccv1p1/LOM/ccv1p1_lommanifest_v1p0.xsd", xml.root.attributes['schemaLocation'].value
    assert_equal "http://ltsc.ieee.org/xsd/imsccv1p1/LOM/resource", xml.namespaces['xmlns:lom']
    assert_equal "http://ltsc.ieee.org/xsd/imsccv1p1/LOM/manifest", xml.namespaces['xmlns:lomimscc']
    assert_equal "http://www.w3.org/2001/XMLSchema-instance", xml.namespaces['xmlns:xsi']
    assert_equal "http://www.imsglobal.org/xsd/imsccv1p1/imscp_v1p1", xml.namespaces['xmlns']
  end

  def test_imsmanifest_has_a_schema
    xml = get_imsmanifest_xml
    assert_equal "IMS Common Cartridge", xml.xpath('//xmlns:manifest/xmlns:metadata/xmlns:schema').text
  end

  def test_imsmanifest_has_a_schemaversion
    xml = get_imsmanifest_xml
    assert_equal "1.1.0", xml.xpath('//xmlns:manifest/xmlns:metadata/xmlns:schemaversion').text
  end

  def test_imsmanifest_has_the_course_fullname
    xml = get_imsmanifest_xml
    assert_equal "My Course", xml.xpath('//xmlns:manifest/xmlns:metadata/lomimscc:lom/lomimscc:general/lomimscc:title/lomimscc:string').text
  end

  def test_imsmanifest_has_the_current_date
    xml = get_imsmanifest_xml
    now = Time.now
    assert_equal now.strftime("%Y-%m-%d"), xml.xpath('//xmlns:manifest/xmlns:metadata/lomimscc:lom/lomimscc:lifeCycle/lomimscc:contribute/lomimscc:date/lomimscc:dateTime').text
  end

  def test_imsmanifest_has_the_copyright_restriction
    xml = get_imsmanifest_xml
    assert_equal "yes", xml.xpath('//xmlns:manifest/xmlns:metadata/lomimscc:lom/lomimscc:rights/lomimscc:copyrightAndOtherRestrictions/lomimscc:value').text
  end

  def test_imsmanifest_has_the_copyright_description
    xml = get_imsmanifest_xml
    assert_equal 'Private (Copyrighted) - http://en.wikipedia.org/wiki/Copyright', xml.xpath('//xmlns:manifest/xmlns:metadata/lomimscc:lom/lomimscc:rights/lomimscc:description/lomimscc:string').text
  end

  def test_imsmanifest_has_an_organization
    xml = get_imsmanifest_xml

    organization = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization').first
    assert organization
    assert_equal 'org_1', organization.attributes['identifier'].value
    assert_equal 'rooted-hierarchy', organization.attributes['structure'].value

    item = organization.xpath('xmlns:item').first
    assert item
    assert 'LearningModules', item.attributes['identifier'].value
  end

  def test_imsmanifest_has_items_under_organization
    xml = get_imsmanifest_xml

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[1]').first
    assert item
    assert_equal "iebbd12be3d1d1ba16e241599099c4795", item.attributes['identifier'].value
    assert_equal 'week 0', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[2]').first
    assert item
    assert_equal "i84cbfb8e81c780e847d0087e024dd2f2", item.attributes['identifier'].value
    assert_equal 'week 1', item.xpath('xmlns:title').text
  end

  def test_imsmanifest_has_sub_items
    xml = get_imsmanifest_xml

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[1]/xmlns:item[1]').first
    assert item
    assert_equal "ibc48cce1126bca1ffe34877330f33864", item.attributes['identifier'].value
    assert_equal 'Create a Rails site', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[1]/xmlns:item[2]').first
    assert item
    assert_equal "i4415a1a262d5e1a5759802e73f207a01", item.attributes['identifier'].value
    assert_equal 'About Your Instructor', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[2]/xmlns:item[1]').first
    assert item
    assert_equal "i485c622e5b692e8989fee0472c218726", item.attributes['identifier'].value
    assert_equal 'Announcements', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[2]/xmlns:item[2]').first
    assert item
    assert_equal "ia854661225b2b463d5c61a219a8dbbc0", item.attributes['identifier'].value
    assert_equal 'Section 1', item.xpath('xmlns:title').text
  end

  def test_imsmanifest_has_a_resource
    xml = get_imsmanifest_xml

    resource = xml.xpath('//xmlns:manifest/xmlns:resources/xmlns:resource').first
    assert resource
    assert_equal 'syllabus', resource.attributes['intendeduse'].value
    assert_equal 'course_settings/syllabus.html', resource.attributes['href'].value
    assert_equal 'associatedcontent/imscc_xmlv1p1/learning-application-resource', resource.attributes['type'].value
    assert_equal 'i056ad8a52e3d89b15c15c97434aa0e91', resource.attributes['identifier'].value
  end

  def test_imsmanifest_has_an_assignment_resource
    xml = get_imsmanifest_xml

    resource = xml.xpath('//xmlns:manifest/xmlns:resources/xmlns:resource[2]').first
    assert resource
    assert_equal 'associatedcontent/imscc_xmlv1p1/learning-application-resource', resource.attributes['type'].value
    assert_equal 'i0f77b146a52ac0f709e1690512154726/create-a-rails-site.html', resource.attributes['href'].value
    assert_equal 'i0f77b146a52ac0f709e1690512154726', resource.attributes['identifier'].value

    file = resource.xpath('xmlns:file[@href="i0f77b146a52ac0f709e1690512154726/create-a-rails-site.html"]').first
    assert file

    file = resource.xpath('xmlns:file[@href="i0f77b146a52ac0f709e1690512154726/assignment_settings.xml"]').first
    assert file
  end

  def test_imsmanifest_has_a_weblink_resource
    xml = get_imsmanifest_xml

    resource = xml.xpath('//xmlns:manifest/xmlns:resources/xmlns:resource[3]').first
    assert resource
    assert_equal 'imswl_xmlv1p1', resource.attributes['type'].value
    assert_equal 'ibd69090f0854ccc9bc06276117c9fffd', resource.attributes['identifier'].value

    file = resource.xpath('xmlns:file[@href="ibd69090f0854ccc9bc06276117c9fffd.xml"]').first
    assert file
  end

  def test_imsmanifest_has_a_discussion_topic_resource
    xml = get_imsmanifest_xml

    resource = xml.xpath('//xmlns:manifest/xmlns:resources/xmlns:resource[4]').first
    assert resource
    assert_equal 'imsdt_xmlv1p1', resource.attributes['type'].value
    assert_equal 'i8a209c39591f6092d924695fca34d98c', resource.attributes['identifier'].value

    file = resource.xpath('xmlns:file[@href="i8a209c39591f6092d924695fca34d98c.xml"]').first
    assert file

    dependency = resource.xpath('xmlns:dependency[@identifierref="i05a5b1468af5e9257a2f6b0827a0bd96"]').first
    assert dependency

    resource = xml.xpath('//xmlns:manifest/xmlns:resources/xmlns:resource[5]').first
    assert resource
    assert_equal 'associatedcontent/imscc_xmlv1p1/learning-application-resource', resource.attributes['type'].value
    assert_equal 'i05a5b1468af5e9257a2f6b0827a0bd96', resource.attributes['identifier'].value
    assert_equal 'i05a5b1468af5e9257a2f6b0827a0bd96.xml', resource.attributes['href'].value

    file = resource.xpath('xmlns:file[@href="i05a5b1468af5e9257a2f6b0827a0bd96.xml"]').first
    assert file
  end

  def test_imsmanifest_has_a_webcontent_resource
    xml = get_imsmanifest_xml

    resource = xml.xpath('//xmlns:manifest/xmlns:resources/xmlns:resource[6]').first
    assert resource
    assert_equal 'webcontent', resource.attributes['type'].value
    assert_equal 'iba86a128db9938df9fcb00979b436e1f', resource.attributes['identifier'].value
    assert_equal 'wiki_content/instructor-resources.html', resource.attributes['href'].value

    file = resource.xpath('xmlns:file[@href="wiki_content/instructor-resources.html"]').first
    assert file
  end
end
