module Moodle2CC::CC
  module Resource
    def self.included(klass)
      klass.class_eval do
        attr_accessor :mod, :identifier, :id, :title, :indent
      end
    end

    def self.get_from_mod(mod, position=0)
      case mod.mod_type
      when 'assignment', 'workshop'
        Assignment.new(mod, position)
      when 'resource'
        if mod.type == 'file'
          WebLink.new(mod)
        elsif mod.type == 'html'
          WebContent.new(mod)
        end
      when 'forum'
        DiscussionTopic.new(mod, position)
      when 'quiz', 'questionnaire', 'choice'
        Assessment.new(mod, position)
      when 'wiki'
        Wiki.new(mod)
      when 'label'
        html = Nokogiri::HTML(mod.content)
        if html.text == mod.content && mod.content.length < 50 # label doesn't contain HTML
          Label.new(mod)
        else
          WebContent.new(mod)
        end
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
