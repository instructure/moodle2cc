require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  class ImsManifestGeneratorTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @course = Moodle2CC::CanvasCC::Model::Course.new
      @course.identifier = 'manifiest_identifier'
      @tmpdir = Dir.mktmpdir
    end

    def teardown
      FileUtils.rm_r @tmpdir
    end

    def test_ims_manifest_schema
      @course.identifier = 'manifiest_identifier'
      @course.title = 'Course Title'
      @course.copyright = 'copyright text'
      xml = write_xml(@course)
      assert_xml_schema xml
    end

    def test_manifest
      @course.identifier = 'manifiest_identifier'
      xml = write_xml(@course)
      assert_equal('CC_838643504692779b6dbd3dab51ff7eb4', xml.at_xpath('//xmlns:manifest/@identifier').value)
    end

    class MetadataTest < ImsManifestGeneratorTest
      def test_manifest_metadata
        @course.title = 'Course Title'

        xml =write_xml(@course)
        assert_equal('IMS Common Cartridge', xml.at_xpath('/xmlns:manifest/xmlns:metadata/xmlns:schema').text)
        assert_equal('1.1.0', xml.at_xpath('/xmlns:manifest/xmlns:metadata/xmlns:schemaversion').text)

        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        assert_equal('Course Title', lom.at_xpath('lomimscc:general/lomimscc:title/lomimscc:string').text)
      end


      def test_has_copyright
        @course.copyright = 'copyright text'
        xml = write_xml(@course)
        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        assert_equal('yes', lom.at_xpath('lomimscc:rights/lomimscc:copyrightAndOtherRestrictions/lomimscc:value').text)
        assert_equal('copyright text', lom.
          at_xpath('lomimscc:rights/lomimscc:description/lomimscc:string').text)
      end

      def test_no_copyright
        xml = write_xml(@course)
        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        assert_equal('no', lom.at_xpath('lomimscc:rights/lomimscc:copyrightAndOtherRestrictions/lomimscc:value').text)
        assert_nil(lom.at_xpath('lomimscc:rights/lomimscc:description/lomimscc:string'))
      end

    end

    class ResourcesTests < ImsManifestGeneratorTest

      def test_course_settings_resource
        canvas_module = Moodle2CC::CanvasCC::Model::CanvasModule.new
        @course.canvas_modules << canvas_module
        xml = write_xml(@course)
        resources_node = xml.%('manifest/resources')
        assert_equal('course_settings/canvas_export.txt', resources_node.at_xpath('xmlns:resource/@href').value)
        assert_equal('associatedcontent/imscc_xmlv1p1/learning-application-resource', resources_node.at_xpath('xmlns:resource/@type').value)
        assert_equal('CC_838643504692779b6dbd3dab51ff7eb4_settings', resources_node.at_xpath('xmlns:resource/@identifier').value)
        files = resources_node.xpath('xmlns:resource/xmlns:file/@href').map(&:value)
        files.must_include('course_settings/course_settings.xml')
        files.must_include('course_settings/module_meta.xml')
      end

      def test_resource
        resource = Moodle2CC::CanvasCC::Model::Resource.new
        resource.identifier = 'resource_identifier'
        resource.type = 'resource_type'
        resource.href = 'resource_href'
        resource.files << 'file_1'
        resource.files << 'file_2'
        @course.resources << resource
        xml = write_xml(@course)
        base_node = xml.at_xpath("/xmlns:manifest/xmlns:resources/xmlns:resource[@identifier='resource_identifier']")
        assert_equal(base_node.at_xpath('@type').value, 'resource_type')
        assert_equal(base_node.at_xpath('@href').value, 'resource_href')
        assert_equal(base_node.xpath("xmlns:file[@href='file_1']").count, 1)
        assert_equal(base_node.xpath("xmlns:file[@href='file_2']").count, 1)
      end
    end

    class OrganizationTests < ImsManifestGeneratorTest
      def test_organizations
        canvas_module = Moodle2CC::CanvasCC::Model::CanvasModule.new
        canvas_module.title = 'my module title'
        canvas_module.identifier = 'my_id'
        @course.canvas_modules << canvas_module
        xml = write_xml(@course)
        org_node = xml.at_xpath('/xmlns:manifest/xmlns:organizations/xmlns:organization')
        assert_equal('rooted-hierarchy', org_node.at_xpath('@structure').value)
        assert_equal('org_1', org_node.at_xpath('@identifier').value)
        assert_equal('module_011ed73876357cbeeb11abdc2b7e1c0b', org_node.at_xpath('xmlns:item/@identifier').value)
        assert_equal('my module title', org_node.%('item/title').text)
      end
    end

    private

    def manifest_path
      File.join(@tmp_dir, Moodle2CC::CanvasCC::ImsManifestGenerator::MANIFEST_FILE_NAME)
    end

    def assert_xml_schema(xml)
      xsd = Nokogiri::XML::Schema(File.read(fixture_path(File.join('common_cartridge', 'schema', 'ccv1p1_imscp_v1p2_v1p0.xsd'))))
      assert_empty(xsd.validate(xml))
    end

    def write_xml(course)
      Moodle2CC::CanvasCC::ImsManifestGenerator.new(@tmpdir, course).write
      Nokogiri::XML(File.read(File.join(@tmpdir, Moodle2CC::CanvasCC::ImsManifestGenerator::MANIFEST_FILE_NAME)))
    end
  end
end