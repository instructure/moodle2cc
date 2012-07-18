module Moodle2CC::CC
  class Assignment
    include CCHelper
    include Resource


    attr_accessor :body

    def initialize(mod, position=0)
      super
      @body = convert_file_path_tokens(mod.description)
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

    def create_resource_node(resources_node)
      href = "#{identifier}/#{file_slug(@title)}.html"
      resources_node.resource(
        :href => href,
        :type => LOR,
        :identifier => identifier
      ) do |resource_node|
        resource_node.file(:href => href)
        create_resource_sub_nodes(resource_node)
      end
    end

    def create_resource_sub_nodes(resource_node)
    end

    def create_files(export_dir)
      create_html(export_dir)
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
  end
end
