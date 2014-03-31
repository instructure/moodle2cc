module Moodle2CC::Moodle2::Parsers
  class ResourceParser
    include ParserHelper

    RESOURCE_XML = 'resource.xml'
    RESOURCE_MODULE_NAME = 'resource'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, RESOURCE_MODULE_NAME)
      activity_dirs.map { |dir| parse_resource(dir) }
    end

    private

    def parse_resource(dir)
      resource = Moodle2CC::Moodle2::Models::Resource.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, RESOURCE_XML)) do |f|
        resource_xml = Nokogiri::XML(f).at_xpath('/activity/resource')
        resource.id = resource_xml.at_xpath('@id').value
        resource.intro = parse_text(resource_xml, 'intro')
        resource.intro_format = parse_text(resource_xml, 'introformat')
        resource.to_be_migrated = parse_text(resource_xml, 'tobemigrated')
        resource.legacy_files = parse_text(resource_xml, 'legacyfiles')
        resource.legacy_files_last = parse_text(resource_xml, 'legacyfileslast')
        resource.display = parse_text(resource_xml, 'display')
        resource.display_options = parse_text(resource_xml, 'displayoptions')
        resource.filter_files = parse_text(resource_xml, 'filterfiles')
      end
      parse_module(activity_dir, resource)

      resource
    end

  end
end