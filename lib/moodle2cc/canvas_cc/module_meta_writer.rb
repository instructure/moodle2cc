class Moodle2CC::CanvasCC::ModuleMetaWriter

  def initialize(*canvas_modules)
    @canvas_modules = canvas_modules
  end

  def write
    Nokogiri::XML::Builder.new do |xml|
      xml.modules(
        'xmlns' => 'http://canvas.instructure.com/xsd/cccv1p0',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd'
      ){ |xml|
        @canvas_modules.each{ |mod| canvas_module(mod, xml)}

      }
    end.to_xml
  end

  private

  def canvas_module(mod, xml)
    xml.module('identifier' => mod.identifier){
      xml.title mod.title
      xml.workflow_state mod.workflow_state
      xml.position mod.position if mod.position
    }
  end

end