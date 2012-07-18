module Moodle2CC::Canvas
  class WebLink < Moodle2CC::CC::WebLink
    include Resource

    def create_module_meta_item_elements(item_node)
      item_node.identifierref @identifier

      uri = URI.parse(@url)
      if uri.scheme
        item_node.url @url
        item_node.content_type 'ExternalUrl'
      else
        item_node.content_type 'Attachment'
      end
    end
  end
end
