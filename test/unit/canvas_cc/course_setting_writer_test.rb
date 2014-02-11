require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanmvasCC
  class CourseSettingWriterTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @course = Moodle2CC::CanvasCC::Model::Course.new
    end

    def teardown
      # Do nothing
    end

    def test_schema
      xml = writer(@course, 'identifier').write
      assert_xml_schema xml
    end

    def test_course_settings_xml
      @course.title = 'course title'
      @course.course_code = 'course code'

      xml = Nokogiri::XML(writer(@course, 'setting_id').write)
      assert_equal('setting_id', xml.at_xpath('/xmlns:course/@identifier').text)
      assert_equal('course title', xml.at_xpath('/xmlns:course/xmlns:title').text)
      assert_equal('course code', xml.at_xpath('/xmlns:course/xmlns:course_code').text)
    end

    private

    def writer(course, identifier)
      Moodle2CC::CanvasCC::CourseSettingWriter.new(course, identifier)
    end

    def assert_xml_schema(xml)
      xml = Nokogiri::XML(xml)
      xsd = Nokogiri::XML::Schema(File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd'))))
      assert_empty(xsd.validate(xml))
    end

  end
end