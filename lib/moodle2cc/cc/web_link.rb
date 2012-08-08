module Moodle2CC::CC
  class WebLink
    include CCHelper
    include Resource

    attr_accessor :url, :external_link, :href

    def initialize(mod)
      super
      @url = mod.reference.to_s.strip
      @external_link = self.class.external_link?(mod)
      @href = @external_link ? "#{@identifier}.xml" : File.join(WEB_RESOURCES_FOLDER, @url)
      @identifier = create_key(@href, 'resource_') unless @external_link
    end

    def self.create_resource_key(mod)
      unless external_link?(mod)
        create_key(File.join(WEB_RESOURCES_FOLDER, mod.reference), 'resource_')
      else
        super
      end
    end

    def self.external_link?(mod)
      begin
        !!URI.parse(mod.reference.to_s.strip.gsub(/\s/, '+')).scheme
      rescue URI::InvalidURIError
        !!mod.reference.strip.match(/^https?\:\/\//)
      end
    end

    def create_resource_node(resources_node)
      if @external_link
        resources_node.resource(
          :type => WEB_LINK,
          :identifier => identifier
        ) do |resource_node|
          resource_node.file(:href => href)
        end
      else
        resources_node.resource(
          :type => WEBCONTENT,
          :href => href,
          :identifier => identifier
        ) do |resource_node|
          resource_node.file(:href => href)
        end
      end
    end

    def create_files(export_dir)
      create_xml(export_dir)
    end

    def create_xml(export_dir)
      return unless @external_link
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
