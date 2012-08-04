module Moodle2CC::CC
  class Assignment
    include CCHelper
    include Resource

    attr_accessor :body, :meta_fields

    def initialize(mod, position=0)
      super
      @body = convert_file_path_tokens(mod.description)
      @meta_fields = build_meta_fields(mod)
      @rel_path = File.join(CC_ASSIGNMENT_FOLDER, "#{file_slug(@title)}.html")
      @resource_type = nil
    end
    
    # Common Cartridge doesn't have anywhere to put assignment meta data like this
    # So add them as HTML meta fields in the HTML file
    def build_meta_fields(mod)
      fields = {}
      %w{mod_type assignment_type}.each do |key|
        fields[key] = mod.send(key) if mod.respond_to?(key)
      end
      if mod.grade_item
        Moodle2CC::Moodle::GradeItem::PROPERTIES.each do |key|
          fields[key] = mod.grade_item.send(key) if mod.grade_item.respond_to?(key)
        end
      end
      
      fields
    end

    def create_resource_node(resources_node)
      resources_node.resource(
        :href => @rel_path,
        :type => @resource_type || WEBCONTENT,
        :identifier => identifier
      ) do |resource_node|
        resource_node.file(:href => @rel_path)
        create_resource_sub_nodes(resource_node)
        # todo if CC 1.2 add assignment meta tag
      end
    end

    def create_resource_sub_nodes(resource_node)
    end

    def create_files(export_dir)
      create_html(export_dir)
    end

    def create_html(export_dir)
      template = File.expand_path('../templates/assignment.html.erb', __FILE__)
      path = File.join(export_dir, @rel_path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        erb = ERB.new(File.read(template))
        file.write(erb.result(binding))
      end
    end
  end
end
