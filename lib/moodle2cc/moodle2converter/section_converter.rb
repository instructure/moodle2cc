module Moodle2CC
  class Moodle2Converter::SectionConverter
    include Moodle2Converter::ConverterHelper

    ACTIVITY_CONVERTERS = {
        Moodle2::Models::Book => Moodle2Converter::BookConverter
    }

    def initialize
      @converters ={}
    end

    def convert(moodle_section)
      canvas_module = CanvasCC::Models::CanvasModule.new
      canvas_module.identifier = generate_unique_identifier_for(moodle_section.id, MODULE_SUFFIX)
      canvas_module.title = moodle_section.name
      canvas_module.workflow_state = moodle_section.visible ? CanvasCC::Models::WorkflowState::ACTIVE : CanvasCC::Models::WorkflowState::UNPUBLISHED
      canvas_module.module_items += moodle_section.activities.map { |a| convert_activity(a) }.flatten.compact

      canvas_module
    end

    def convert_activity(moodle_activity)
      begin
        activity_converter_for(moodle_activity).convert_to_module_items(moodle_activity)
      rescue Exception => e
        puts e.message
      end
    end

    def convert_to_module_items(moodle_activity)
      module_item = CanvasCC::Models::ModuleItem.new
      module_item.identifier = generate_unique_identifier
      module_item.workflow_state = CanvasCC::Models::WorkflowState::ACTIVE
      module_item.title = moodle_activity.name
      module_item.identifierref = generate_unique_identifier_for_activity(moodle_activity)
      module_item.content_type = activity_content_type(moodle_activity)
      module_item.indent = '0'

      [module_item]
    end

    private

    def activity_converter_for(moodle_activity)
      @converters[moodle_activity.class] ||=
        ACTIVITY_CONVERTERS[moodle_activity.class] ? ACTIVITY_CONVERTERS[moodle_activity.class].new : self
    end

  end
end