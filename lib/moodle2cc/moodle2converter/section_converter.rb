module Moodle2CC
  class Moodle2Converter::SectionConverter
    include Moodle2Converter::ConverterHelper


    def convert(moodle_section)
      canvas_module = CanvasCC::Models::CanvasModule.new
      canvas_module.identifier = generate_unique_identifier_for(moodle_section.id, MODULE_SUFFIX)
      canvas_module.title = moodle_section.name
      canvas_module.workflow_state = moodle_section.visible ? CanvasCC::Models::WorkflowState::ACTIVE : CanvasCC::Models::WorkflowState::UNPUBLISHED
      canvas_module.module_items = moodle_section.activities.map{|a| convert_activity(a)}

      canvas_module
    end

    def convert_activity(moodle_activity)
      module_item = CanvasCC::Models::ModuleItem.new
      module_item.identifier = generate_unique_identifier
      module_item.workflow_state = CanvasCC::Models::WorkflowState::ACTIVE
      module_item.title = moodle_activity.name
      module_item.identifierref = generate_unique_identifier_for_activity(moodle_activity)
      module_item.content_type = CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE
      module_item.indent = '0'
      module_item
    end

  end
end