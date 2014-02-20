require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  class CourseSettingWriterTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @course = Moodle2CC::CanvasCC::Model::Course.new
      @tmpdir = Dir.mktmpdir
      Dir.mkdir(File.join(@tmpdir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    def teardown
      FileUtils.rm_r @tmpdir
    end

    def test_schema
      @course.identifier = 'identifier'
      xml = write_xml(@course)
      assert_xml_schema xml
    end

    def test_course_settings_xml
      @course.title = 'course title'
      @course.course_code = 'course code'
      @course.identifier = 'setting_id'
      xml = write_xml(@course)
      assert_equal('CC_60190d67bf4f64c95ba4d0d5745d529d_settings', xml.at_xpath('/xmlns:course/@identifier').text)
      assert_equal('course title', xml.at_xpath('/xmlns:course/xmlns:title').text)
      assert_equal('course code', xml.at_xpath('/xmlns:course/xmlns:course_code').text)
    end

    private

    def write_xml(course)
      Moodle2CC::CanvasCC::CourseSettingWriter.new(@tmpdir, course).write
      Nokogiri::XML(File.read(File.join( @tmpdir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, Moodle2CC::CanvasCC::CourseSettingWriter::COURSE_SETTINGS_FILE)))
    end

    def assert_xml_schema(xml)
      xsd = Nokogiri::XML::Schema(File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd'))))
      assert_empty(xsd.validate(xml))
    end

  end
end