module Moodle2CC::CC
  class WebContent
    include CCHelper

    attr_accessor :id, :title, :body

    def initialize(mod)
      @id = mod.id
      @title = mod.name
      @body = mod.alltext
    end

    def identifier
      create_key(id, 'resource_')
    end

    def create_files(export_dir)
      create_html(export_dir)
    end

    def create_html(export_dir)
      template = File.expand_path('../templates/wiki_content.html.erb', __FILE__)
      path = File.join(export_dir, 'wiki_content', "#{file_slug(title)}.html")
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        erb = ERB.new(File.read(template))
        file.write(erb.result(binding))
      end
    end
  end
end
