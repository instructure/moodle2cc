require 'minitest/autorun'
require 'test_helper'
require 'moodle2cc'
require 'nokogiri'

class TestUnitCCConverter < MiniTest::Test
  include TestHelper

  def setup
    convert_moodle_backup('canvas')
  end

  def teardown
    clean_tmp_folder
  end

  def test_it_has_the_path_to_the_imscc_package
    assert_equal File.expand_path("../../../tmp/my-course.imscc", __FILE__), @converter.imscc_path
  end

  def test_it_creates_imscc_package
    assert File.exist?(@converter.imscc_path)
  end

  def test_it_creates_imsmanifest_xml
    Zip::File.open(@converter.imscc_path) do |zipfile|
      assert zipfile.find_entry("imsmanifest.xml")
    end
  end

  def test_imsmanifest_has_manifest_root
    xml = get_imsmanifest_xml
    assert_equal "manifest", xml.root.name
    assert_equal "i24f498fba015133ae97c6e6693a32b4d", xml.root.attributes['identifier'].value
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
    now = Time.now.utc
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
    assert_equal 'Week 0', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[2]').first
    assert item
    assert_equal "i84cbfb8e81c780e847d0087e024dd2f2", item.attributes['identifier'].value
    assert_equal 'Week 1', item.xpath('xmlns:title').text
  end

  def test_imsmanifest_does_not_create_item_for_invisible_sections
    xml = get_imsmanifest_xml

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[@identifier="i9a57aafbbb5993c28a89c2e363e97f87"]').first
    refute item, 'invisible section has item node'
  end

  def test_imsmanifest_has_sub_items
    xml = get_imsmanifest_xml

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[1]/xmlns:item[1]').first
    assert item
    assert_equal "i421aa3e876264b528cdc0c22cf9b2124", item.attributes['identifier'].value
    assert_equal "i2bbef1184ce7da2a0f6d9038cb872c28", item.attributes['identifierref'].value
    assert_equal 'This is the Syllabus', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[1]/xmlns:item[2]').first
    assert item
    assert_equal "i10241816e5909d8e76da003b2814c6a4", item.attributes['identifier'].value
    assert_equal "i6b162484accdf6081cea43b39219d129", item.attributes['identifierref'].value
    assert_equal 'Create a Rails site', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[1]/xmlns:item[3]').first
    assert item
    assert_equal "i966437b815a49aad86a356bc8aa8f24a", item.attributes['identifier'].value
    assert_equal "i15aaccec404aa2ad557108a689bbba8f", item.attributes['identifierref'].value
    assert_equal 'About Your Instructor', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[2]/xmlns:item[1]').first
    assert item
    assert_equal "i61c91e0962069aa79c40a406a6c38e3e", item.attributes['identifier'].value
    assert_equal "i9c32ce07701475bf3eb14257f2d6def4", item.attributes['identifierref'].value
    assert_equal 'Week 1 Summary', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[2]/xmlns:item[2]').first
    assert item
    assert_equal "ie8e11ad7a1b32660f6aeaf94948faa22", item.attributes['identifier'].value
    assert_equal "if7091ac80f57e45c757345555327b248", item.attributes['identifierref'].value
    assert_equal 'Announcements', item.xpath('xmlns:title').text

    item = xml.xpath('//xmlns:manifest/xmlns:organizations/xmlns:organization/xmlns:item/xmlns:item[2]/xmlns:item[3]').first
    assert item
    assert_equal "ifcf0624ce811c812c749c53f3c914f20", item.attributes['identifier'].value
    assert_equal "iddbfacadb16c78a584f81538cd53cc72", item.attributes['identifierref'].value
    assert_equal 'label123', item.xpath('xmlns:title').text
  end

  def test_imsmanifest_has_file_resources
    xml = get_imsmanifest_xml

    resource = xml.xpath('//xmlns:manifest/xmlns:resources/xmlns:resource[@identifier="i2fbc9b5ef920655b8240824d3d7b677a"]').first
    assert resource, 'resources does not exist for "web_resources/folder/test.txt" file'
    assert_equal 'webcontent', resource.attributes['type'].value
    assert_equal 'web_resources/folder/test.txt', resource.attributes['href'].value
    assert resource.xpath('xmlns:file[@href="web_resources/folder/test.txt"]').first

    resource = xml.xpath('//xmlns:manifest/xmlns:resources/xmlns:resource[@identifier="ib98bb8ec201a97840ae4ed4bb40207c0"]').first
    assert resource, 'resources does not exist for "web_resources/test.txt" file'
    assert_equal 'webcontent', resource.attributes['type'].value
    assert_equal 'web_resources/test.txt', resource.attributes['href'].value
    assert resource.xpath('xmlns:file[@href="web_resources/test.txt"]').first
  end

  def test_it_deletes_all_files_except_imscc
    refute File.exist? @converter.imscc_tmp_path
    assert File.exist? @converter.imscc_path
  end
end
