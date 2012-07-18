module Moodle2CC::Canvas
  module Resource
    def create_module_meta_item_node(items_node, position)
      items_node.item(:identifier => create_mod_key(@mod)) do |item_node|
        item_node.title @title
        item_node.position position
        item_node.new_tab ''
        item_node.indent @indent
        create_module_meta_item_elements(item_node)
      end
    end

    def create_module_meta_item_elements(item_node)
    end
  end
end
