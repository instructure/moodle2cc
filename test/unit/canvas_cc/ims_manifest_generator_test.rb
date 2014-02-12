require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  class ImsManifestGeneratorTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @course = Moodle2CC::CanvasCC::Model::Course.new
    end

    def test_ims_manifest_schema
      @course.identifier = 'manifiest_identifier'
      @course.title = 'Course Title'
      @course.copyright = 'copyright text'
      xml = generator(@course).generate
      assert_xml_schema xml
    end

    def test_manifest
      @course.identifier = 'manifiest_identifier'
      xml = Nokogiri::XML(generator(@course).generate)
      assert_equal('manifiest_identifier', xml.at_xpath('//xmlns:manifest/@identifier').value)
    end

    class MetadataTest < ImsManifestGeneratorTest
      def test_manifest_metadata
        @course.title = 'Course Title'

        xml = Nokogiri::XML(generator(@course).generate)
        assert_equal('IMS Common Cartridge', xml.at_xpath('/xmlns:manifest/xmlns:metadata/xmlns:schema').text)
        assert_equal('1.1.0', xml.at_xpath('/xmlns:manifest/xmlns:metadata/xmlns:schemaversion').text)

        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        assert_equal('Course Title', lom.at_xpath('lomimscc:general/lomimscc:title/lomimscc:string').text)
      end


      def test_has_copyright
        @course.copyright = 'copyright text'
        xml = Nokogiri::XML(generator(@course).generate)
        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        assert_equal('yes', lom.at_xpath('lomimscc:rights/lomimscc:copyrightAndOtherRestrictions/lomimscc:value').text)
        assert_equal('copyright text', lom.
          at_xpath('lomimscc:rights/lomimscc:description/lomimscc:string').text)
      end

      def test_no_copyright
        xml = Nokogiri::XML(generator(@course).generate)
        lom = xml.at_xpath('/xmlns:manifest/xmlns:metadata/lomimscc:lom')
        assert_equal('no', lom.at_xpath('lomimscc:rights/lomimscc:copyrightAndOtherRestrictions/lomimscc:value').text)
        assert_nil(lom.at_xpath('lomimscc:rights/lomimscc:description/lomimscc:string'))
      end

    end

    class ResourcesTests < ImsManifestGeneratorTest
      def test_resource
        resource = Moodle2CC::CanvasCC::Model::Resource.new
        resource.identifier = 'resource_identifier'
        resource.type = 'resource_type'
        resource.href = 'resource_href'
        resource.files << 'file_1'
        resource.files << 'file_2'
        @course.resources << resource
        xml = Nokogiri(generator(@course).generate)
        base_node = xml.at_xpath("/xmlns:manifest/xmlns:resources/xmlns:resource[@identifier='resource_identifier']")
        assert_equal(base_node.at_xpath('@type').value, 'resource_type')
        assert_equal(base_node.at_xpath('@href').value, 'resource_href')
        assert_equal(base_node.xpath("xmlns:file[@href='file_1']").count, 1)
        assert_equal(base_node.xpath("xmlns:file[@href='file_2']").count, 1)
      end
    end

    private

    def manifest_path
      File.join(@tmp_dir, Moodle2CC::CanvasCC::ImsManifestGenerator::MANIFEST_FILE_NAME)
    end

    def assert_xml_schema(xml)
      xml = Nokogiri::XML(xml)
      xsd = Nokogiri::XML::Schema(File.read(fixture_path(File.join('common_cartridge', 'schema', 'ccv1p1_imscp_v1p2_v1p0.xsd'))))
      assert_empty(xsd.validate(xml))
    end

    def generator(course)
      Moodle2CC::CanvasCC::ImsManifestGenerator.new(course)
    end
  end
end