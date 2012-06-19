module Moodle2CC::CC
  class Resource
    include CCHelper

    attr_accessor :identifier, :type, :href, :intendeduse, :content,
      :title, :posted_at, :text

    def self.from_manifest(manifest, context)
      resource = Resource.new

      if context.name == 'SECTION'
        number = context.xpath('NUMBER').text
        href = "wiki_content/summary-of-week-#{number}.html"
        resource.href = href
        resource.type = "webcontent"
        resource.identifier = CCHelper.create_key(href, "_resource")
        resource.content = context.xpath('SUMMARY').text
      elsif context.name == 'MOD'
        resource.identifier = CCHelper.create_key(context.xpath("ID"), "_resource")
        modtype = context.xpath("MODTYPE").text

        case modtype
        when "resource"
          if context.xpath("TYPE").text == "file"
            resource.href = context.xpath("REFERENCE").text
            resource.type = "imswl_xmlv1p1"
          end
        when "forum"
          resource.title = context.xpath("NAME").text
          resource.text = context.xpath("INTRO").text
          resource.type = "imsdt_xmlv1p1"
        end
      end

      manifest.resources << resource
      resource
    end
  end
end
