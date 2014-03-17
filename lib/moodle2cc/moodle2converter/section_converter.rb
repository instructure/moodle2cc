module Moodle2CC
  class Moodle2Converter::SectionConverter

    def convert(moodle_section)
      canvas_module = CanvasCC::Models::CanvasModule.new
      canvas_module.identifier = moodle_section.id
      canvas_module.title = moodle_section.name
      canvas_module.workflow_state = moodle_section.visible ? CanvasCC::Models::WorkflowState::ACTIVE : CanvasCC::Models::WorkflowState::UNPUBLISHED
      canvas_module
    end

  end
end