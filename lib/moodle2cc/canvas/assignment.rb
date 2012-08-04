module Moodle2CC::Canvas
  class Assignment < Moodle2CC::CC::Assignment
    include Resource
    SETTINGS_ATTRIBUTES = [:title, :points_possible, :grading_type, :due_at,
      :lock_at, :unlock_at, :all_day, :all_day_date, :submission_types,
      :position, :peer_reviews, :automatic_peer_reviews, :peer_review_count,
      :anonymous_peer_reviews, :assignment_group_identifierref]

    attr_accessor *SETTINGS_ATTRIBUTES

    def initialize(mod, position=0)
      super
      @rel_path = "#{identifier}/#{file_slug(@title)}.html"
      @resource_type = LOR
      @body = convert_file_path_tokens(mod.description)
      @points_possible = mod.grade_item ? mod.grade_item.grade_max : mod.grade
      @grading_type = 'points'
      if mod.time_due.to_i > 0
        @due_at = ims_datetime(Time.at(mod.time_due))
        @all_day = Time.at(mod.time_due).utc.strftime('%H:%M') == '23:59' ? true : false
        if @all_day
          @all_day_date = ims_date(Time.at(mod.time_due))
        end
        if mod.prevent_late
          @lock_at = @due_at
        end
      end
      if mod.time_available.to_i > 0
        @unlock_at = ims_datetime(Time.at(mod.time_available))
      end
      if mod.submission_end.to_i > 0
        @due_at = ims_datetime(Time.at(mod.submission_end))
      end
      @submission_types = get_submission_types(mod)
      @position = position
      @peer_reviews = @automatic_peer_reviews = mod.mod_type == 'workshop'
      @peer_review_count = mod.number_of_student_assessments
      @anonymous_peer_reviews = mod.anonymous
      @assignment_group_identifierref = create_key(mod.section_mod.section.id, 'assignment_group_')
    end

    def get_submission_types(mod)
      if mod.mod_type == 'assignment'
        case mod.assignment_type
        when 'online'
          'online_text_entry'
        when 'upload'
          if mod.var2 == 1
            'online_upload,online_text_entry'
          else
            'online_upload'
          end
        when 'uploadsingle'
          'online_upload'
        else
          'none'
        end
      elsif mod.mod_type == 'workshop'
        submission_types = ['online_text_entry']
        submission_types.unshift('online_upload') if mod.number_of_attachments > 0
        submission_types.join(',')
      end
    end

    def create_resource_sub_nodes(resource_node)
      resource_node.file(:href => File.join(identifier, ASSIGNMENT_SETTINGS))
    end

    def create_files(export_dir)
      super
      create_settings_xml(export_dir)
    end

    def create_settings_xml(export_dir)
      path = File.join(export_dir, identifier, ASSIGNMENT_SETTINGS)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        settings_node = Builder::XmlMarkup.new(:target => file, :indent => 2)
        settings_node.instruct!
        settings_node.assignment(
          :identifier => identifier,
          'xsi:schemaLocation' => "http://canvas.instructure.com/xsd/cccv1p0 http://canvas.instructure.com/xsd/cccv1p0.xsd",
          'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
          'xmlns' => "http://canvas.instructure.com/xsd/cccv1p0"
        ) do |assignment_node|
          SETTINGS_ATTRIBUTES.each do |attr|
            assignment_node.tag!(attr, send(attr)) unless send(attr).nil?
          end
        end
      end
    end

    def create_module_meta_item_elements(item_node)
      item_node.content_type 'Assignment'
      item_node.identifierref @identifier
    end
  end
end
