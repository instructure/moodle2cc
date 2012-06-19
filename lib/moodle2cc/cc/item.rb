module Moodle2CC::CC
  class Item
    include CCHelper

    attr_accessor :identifier, :identifierref, :title, :items

    def initialize
      @items = []
    end

    def self.from_manifest(manifest, context)
      item = Item.new
      if context.name == 'SECTION'
        item.identifier = CCHelper.create_key(context.xpath('ID').text, "item_")
        number = context.xpath('NUMBER').text
        item.title = "week #{number}"

        resource = Resource.from_manifest(manifest, context)
        item.identifierref = resource.identifier

        context.xpath('MODS/MOD').each do |mod|
          item.items << Item.from_manifest(manifest, mod)
        end
      elsif context.name == 'MOD'
        item.identifier = CCHelper.create_key(context.xpath('ID').text, "item_")
        instance = context.xpath('INSTANCE').text

        module_node = manifest.moodle_backup.course.xpath("MODULES/MOD[ID='#{instance}']").first
        item.title = module_node.xpath("NAME").text

        resource = Resource.from_manifest(manifest, module_node)
        item.identifierref = resource.identifier
      end
      item
    end
  end
end
