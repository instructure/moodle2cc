module Moodle2CC::CC
  class WebContent
    include CCHelper
    include Resource

    attr_accessor :body

    def initialize(mod)
      super
      @rel_path = File.join(CC_WIKI_FOLDER, "#{file_slug(@title)}.html")
      body = mod.alltext
      body = mod.content || '' if body.nil? || body.length == 0
      @body = convert_file_path_tokens(body)
    end

    def create_resource_node(resources_node)
      href = @rel_path
      resources_node.resource(
        :type => WEBCONTENT,
        :identifier => identifier,
        :href => href
      ) do |resource_node|
        resource_node.file(:href => href)
      end
    end

    def create_files(export_dir)
      create_html(export_dir)
    end

    def create_html(export_dir)
      template = File.expand_path('../templates/wiki_content.html.erb', __FILE__)
      path = File.join(export_dir, @rel_path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        erb = ERB.new(File.read(template))
        file.write(erb.result(binding))
      end
    end
  end
end
