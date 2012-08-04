module Moodle2CC::Canvas
  class WebContent < Moodle2CC::CC::WebContent
    include Resource
    
    def initialize(mod)
      super
      @rel_path = File.join(WIKI_FOLDER, "#{file_slug(@title)}.html")
    end

    def create_module_meta_item_elements(item_node)
      item_node.content_type 'WikiPage'
      item_node.identifierref @identifier
    end
  end
end
