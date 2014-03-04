require 'spec_helper'

module Moodle2CC::CanvasCC
  describe ModuleMetaWriter do

    let(:canvas_module) { Model::CanvasModule.new }
    let(:tmpdir) { Dir.mktmpdir }

    before :each do
      Dir.mkdir(File.join(tmpdir, CartridgeCreator::COURSE_SETTINGS_DIR))
    end

    after :each do
      FileUtils.rm_r tmpdir
    end

    it 'should have a valid schema' do
      canvas_module.identifier = 'module identifier'
      canvas_module.title = 'test_title'
      canvas_module.workflow_state = 'active'
      canvas_module.position = 0
      xml = write_xml(canvas_module)

      assert_xml_schema(xml)
    end

    it 'should have valid metadata' do
      canvas_module.identifier = 'ident'
      canvas_module.title = 'module title'
      canvas_module.workflow_state = 'active'
      canvas_module.position = 0
      xml = write_xml(canvas_module)

      expect(xml.at_xpath('xmlns:modules/xmlns:module/@identifier').text).to eq('module_67217d8b401cf5e72bbf5103d60f3e97')
      expect(xml.%('modules/module/title').text).to eq('module title')
      expect(xml.%('modules/module/workflow_state').text).to eq('active')
      expect(xml.%('modules/module/position').text).to eq('0')
    end

    private

    def write_xml(mod)
      writer = ModuleMetaWriter.new(tmpdir, mod)
      writer.write
      path = File.join(tmpdir,
                       CartridgeCreator::COURSE_SETTINGS_DIR,
                       ModuleMetaWriter::MODULE_META_FILE)
      Nokogiri::XML(File.read(path))
    end

    def assert_xml_schema(xml)
      valid_schema = File.read(fixture_path(File.join('common_cartridge', 'schema', 'cccv1p0.xsd')))
      xsd = Nokogiri::XML::Schema(valid_schema)
      expect(xsd.validate(xml)).to be_empty
    end

  end
end