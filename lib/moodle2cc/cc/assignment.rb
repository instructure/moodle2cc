module Moodle2CC::CC
  class Assignment
    include CCHelper

    SETTINGS_ATTRIBUTES = [:title, :points_possible, :grading_type, :due_at,
      :lock_at, :unlock_at, :all_day, :all_day_date, :submission_types,
      :position, :assignment_group_identifierref]

    attr_accessor :id, :body, *SETTINGS_ATTRIBUTES

    def initialize(mod, position=0)
      @id = mod.id
      @title = mod.name
      @body = convert_file_path_tokens(mod.description)
      @points_possible = mod.grade_item.grade_max
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
      @submission_types = case mod.assignment_type
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
      @position = position
      @assignment_group_identifierref = create_key(mod.section_mod.section.id, 'assignment_group_')
    end

    def identifier
      create_key(id, 'resource_')
    end

    def create_resource_node(resources_node)
      href = "#{identifier}/#{file_slug(@title)}.html"
      resources_node.resource(
        :href => href,
        :type => LOR,
        :identifier => identifier
      ) do |resource_node|
        resource_node.file(:href => href)
        resource_node.file(:href => File.join(identifier, ASSIGNMENT_SETTINGS))
      end
    end

    def create_files(export_dir)
      create_html(export_dir)
      create_settings_xml(export_dir)
    end

    def create_html(export_dir)
      template = File.expand_path('../templates/assignment.html.erb', __FILE__)
      path = File.join(export_dir, identifier, "#{file_slug(title)}.html")
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        erb = ERB.new(File.read(template))
        file.write(erb.result(binding))
      end
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
  end
end
