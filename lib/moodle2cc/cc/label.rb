module Moodle2CC::CC
  class Label
    include CCHelper
    include Resource

    def create_module_meta_item_elements(item_node)
      item_node.content_type 'ContextModuleSubHeader'
    end
  end
end
