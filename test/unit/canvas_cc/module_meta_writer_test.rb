require 'minitest/autorun'
require 'moodle2cc'
require 'test_helper'

module CanvasCC
  class ModuleMetaWriterTest < MiniTest::Unit::TestCase
    include TestHelper

    def setup
      @module = Moodle2CC::CanvasCC::Model::CanvasModule.new
      @tmpdir = Dir.mktmpdir
      Dir.mkdir(File.join(@tmpdir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    def teardown
      FileUtils.rm_r @tmpdir
    end

    def test_schema
      @module.identifier = 'module identifier'
      @module.title = 'test_title'
      @module.workflow_state = 'active'
      @module.position = 0
      xml = write_xml(@module)
      assert_xml_schema xml
    end

    def test_module_meta_xml
      @module.identifier = 'ident'
      @module.title = 'module title'
      @module.workflow_state = 'active'
      @module.position = 0
      xml = write_xml(@module)
      assert_equal('module_67217d8b401cf5e72bbf5103d60f3e97', xml.at_xpath('xmlns:modules/xmlns:module/@identifier').text)
      assert_equal('module title', xml.%('modules/module/title').text)
      assert_equal('active', xml.%('modules/module/workflow_state').text)
      assert_equal('0', xml.%('modules/module/position').text)
    end

    private

    def write_xml(mod)
      Moodle2CC::CanvasCC::ModuleMetaWriter.new(@tmpdir, mod).write
      Nokogiri::XML(File.read(File.join(@tmpdir,  Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, Moodle2CC::CanvasCC::ModuleMetaWriter::MODULE_META_FILE)))
    end

    def assert_xml_schema(xml)
      xsd = Nokogiri::XML::Schema(File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd'))))
      assert_empty(xsd.validate(xml))
    end

  end
end