module Moodle2CC
  class Moodle2Converter::SectionConverter
    include Moodle2Converter::ConverterHelper

    ACTIVITY_CONVERTERS = {
      Moodle2::Models::Book => Moodle2Converter::BookConverter,
      Moodle2::Models::Label => Moodle2Converter::LabelConverter,
    }

    DEFAULT_NAME = 'Untitled Module'

    def initialize
      @converters ={}
    end

    def convert(moodle_section)
      canvas_module = CanvasCC::Models::CanvasModule.new
      canvas_module.identifier = generate_unique_identifier_for(moodle_section.id, MODULE_SUFFIX)
      canvas_module.title = truncate_text(moodle_section.name)
      canvas_module.workflow_state = workflow_state(moodle_section.visible)

      canvas_module.module_items += convert_activity(moodle_section) if moodle_section.summary && !moodle_section.summary.strip.empty?
      canvas_module.module_items += moodle_section.activities.map { |a| convert_activity(a) }
      canvas_module.module_items = canvas_module.module_items.flatten.compact

      handle_untitled_module!(canvas_module)

      canvas_module
    end

    def convert_to_summary_page(moodle_section)
      canvas_page = CanvasCC::Models::Page.new
      canvas_page.identifier = generate_unique_identifier_for_activity(moodle_section)
      canvas_page.title = truncate_text(moodle_section.name)
      canvas_page.workflow_state = workflow_state(moodle_section.visible)
      canvas_page.editing_roles = CanvasCC::Models::Page::EDITING_ROLE_TEACHER
      canvas_page.body = moodle_section.summary
      canvas_page
    end

    def convert_activity(moodle_activity)
      begin
        activity_converter_for(moodle_activity).convert_to_module_items(moodle_activity)
      rescue Exception => e
        Moodle2CC::OutputLogger.logger.info e.message
        nil
      end
    end

    def convert_to_module_items(moodle_activity)
      module_item = CanvasCC::Models::ModuleItem.new
      module_item.identifier = generate_unique_identifier
      module_item.workflow_state = workflow_state(moodle_activity.visible)
      module_item.title = truncate_text(moodle_activity.name)
      unless moodle_activity.is_a? Moodle2::Models::Label
        if moodle_activity.is_a? Moodle2::Models::ExternalUrl
          module_item.identifierref = module_item.identifier
          module_item.url = moodle_activity.external_url.gsub(/\s/, '%20')
        elsif moodle_activity.is_a? Moodle2::Models::Resource
          module_item.identifierref = moodle_activity.file.content_hash if moodle_activity.file
        elsif moodle_activity.is_a? Moodle2::Models::Lti
          module_item.identifierref = module_item.identifier
          module_item.url = moodle_activity.url.gsub(/\s/, '%20')
        else
          module_item.identifierref = get_unique_identifier_for_activity(moodle_activity)
        end
      end
      module_item.content_type = activity_content_type(moodle_activity)
      module_item.indent = '0'

      [module_item]
    end

    private

    def activity_converter_for(moodle_activity)
      @converters[moodle_activity.class] ||=
        ACTIVITY_CONVERTERS[moodle_activity.class] ? ACTIVITY_CONVERTERS[moodle_activity.class].new : self
    end

    # If a module has no title, but its first item is a subheader, promote that to the title
    # (per example package provided by a customer)
    def handle_untitled_module!(canvas_module)
      if canvas_module.title.nil? || canvas_module.title.empty?
        if canvas_module.module_items.any? &&
           canvas_module.module_items.first.is_a?(CanvasCC::Models::ModuleItem) &&
           canvas_module.module_items.first.content_type == 'ContextModuleSubHeader'
          canvas_module.title = canvas_module.module_items.shift.title
        else
          canvas_module.title = DEFAULT_NAME
        end
      end
    end

  end
end
