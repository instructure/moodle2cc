module Moodle2CC::Moodle2Converter
  class SectionConverter

    def convert(moodle_section)
      canvas_module = Moodle2CC::CanvasCC::Model::CanvasModule.new
      canvas_module.identifier = moodle_section.id
      canvas_module.title = moodle_section.name
      canvas_module.workflow_state = moodle_section.visible ? 'active' : 'unpublished'
      canvas_module.position = moodle_section.position
      canvas_module
    end

  end
end