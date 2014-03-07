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
          @canvas_modules.each_with_index { |mod, position| canvas_module(mod, xml, position) }
        }
      end.to_xml
      File.open(File.join(@work_dir, Moodle2CC::CanvasCC::CartridgeCreator::COURSE_SETTINGS_DIR, MODULE_META_FILE), 'w') { |f| f.write(xml) }
    end

    private

    def canvas_module(mod, xml, position)
      xml.module('identifier' => mod.identifier) {
        xml.title mod.title
        xml.workflow_state mod.workflow_state
        xml.position(position)
        xml.items { |xml|
          add_module_items_to_xml(mod.module_items, xml)
        }
      }
    end

    def add_module_items_to_xml(module_items, xml)
      module_items.each_with_index do |item, position|
        xml.item('identifier' => item.identifier) { |xml|
          xml.content_type(item.content_type)
          xml.workflow_state(item.workflow_state)
          xml.title(item.title)
          xml.position(position)
          xml.new_tab(item.new_tab) if item.new_tab
          xml.indent(item.indent)
        }
      end
    end

  end
end