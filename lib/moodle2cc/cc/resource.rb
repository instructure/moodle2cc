module Moodle2CC::CC
  module Resource
    def self.included(klass)
      klass.class_eval do
        attr_accessor :mod, :identifier, :id, :title, :indent
      end
    end

    def initialize(mod, *args)
      @mod = mod
      @id = mod.id
      @title = mod.name
      @indent = mod.section_mod.nil? ? 0 : mod.section_mod.indent
      @identifier = create_resource_key(mod)
    end

    def create_files(export_dir)
    end

    def create_resource_node(resources_node)
    end

    def create_organization_item_node(item_node)
      item_node.item(:identifier => create_mod_key(@mod), :identifierref => @identifier) do |sub_item|
        sub_item.title @title
      end
    end

  end
end
