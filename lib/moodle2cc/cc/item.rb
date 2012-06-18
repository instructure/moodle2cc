module Moodle2CC::CC
  class Item
    include CCHelper

    attr_accessor :identifier, :identifierref, :title, :items

    def self.from_manifest(manifest, context)
      item = Item.new
      if context.name == 'SECTION'
        item.identifier = CCHelper.create_key(context.xpath('ID').text, "item_")
        number = context.xpath('NUMBER').text
        item.title = "week #{number}"

        resource = Resource.new
        href = "wiki_content/summary-of-week-#{number}.html"
        resource.href = href
        resource.type = "webcontent"

        file = File.new
        file.href = href
        file.content = context.xpath('SUMMARY').text
        resource.files << file

        item.items = []
        context.xpath('MODS/MOD').each do |mod|
          item.items << Item.from_manifest(manifest, mod)
        end
      elsif context.name == 'MOD'
        item.identifier = CCHelper.create_key(context.xpath('ID').text, "item_")
        instance = context.xpath('INSTANCE').text
        item.title = manifest.moodle_backup.info.xpath("DETAILS/MOD/INSTANCES/INSTANCE[ID='#{instance}']/NAME").text
      end
      item
    end
  end
end
