module Moodle2CC::CC
  class WebLink
    include CCHelper

    attr_accessor :id, :title, :url

    def initialize(mod)
      @id = mod.id
      @title = mod.name
      @url = mod.reference
    end

    def identifier
      create_key(id, 'resource_')
    end

    def create_resource_node(resources_node)
      identifier = create_key(@id, 'resource_')
      resources_node.resource(
        :type => WEB_LINK,
        :identifier => identifier
      ) do |resource_node|
        resource_node.file(:href => "#{identifier}.xml")
      end
    end

    def create_files(export_dir)
      create_xml(export_dir)
    end

    def create_xml(export_dir)
      path = File.join(export_dir, "#{identifier}.xml")
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        settings_node = Builder::XmlMarkup.new(:target => file, :indent => 2)
        settings_node.instruct!
        settings_node.webLink(
          :identifier => identifier,
          'xsi:schemaLocation' => "http://www.imsglobal.org/xsd/imsccv1p1/imswl_v1p1 http://www.imsglobal.org/profile/cc/ccv1p1/ccv1p1_imswl_v1p1.xsd",
          'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
          'xmlns' => "http://www.imsglobal.org/xsd/imsccv1p1/imswl_v1p1"
        ) do |web_link_node|
          web_link_node.title @title
          web_link_node.url(:href => @url)
        end
      end
    end
  end
end
