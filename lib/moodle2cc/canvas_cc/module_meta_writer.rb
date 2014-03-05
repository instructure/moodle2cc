module Moodle2CC::CanvasCC
  class ModuleMetaWriter
    MODULE_META_FILE = 'module_meta.xml'

    def initialize(work_dir, *canvas_modules)
      @work_dir = work_dir
      @canvas_modules = canvas_modules
    end

    def write
      xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.modules(
          'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
          'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
        ) { |xml|
          @canvas_modules.each { |mod| canvas_module(mod, xml) }

        }
      end.to_xml
      File.open(File.join(@work_dir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, MODULE_META_FILE), 'w') { |f| f.write(xml) }
    end

    private

    def canvas_module(mod, xml)
      xml.module('identifier' => mod.identifier) {
        xml.title mod.title
        xml.workflow_state mod.workflow_state
        xml.position mod.position if mod.position
      }
    end

  end
end