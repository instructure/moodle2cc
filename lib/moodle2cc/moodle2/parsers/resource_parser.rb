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
        xml = Nokogiri::XML(f).at_xpath('/activity/resource')
        resource.id = xml.at_xpath('@id').value
        resource.module_id = xml.at_xpath('/activity/@moduleid').value
        resource.name = parse_text(xml, 'name')
        resource.intro = parse_text(xml, 'intro')
        resource.intro_format = parse_text(xml, 'introformat')
        resource.to_be_migrated = parse_text(xml, 'tobemigrated')
        resource.legacy_files = parse_text(xml, 'legacyfiles')
        resource.legacy_files_last = parse_text(xml, 'legacyfileslast')
        resource.display = parse_text(xml, 'display')
        resource.display_options = parse_text(xml, 'displayoptions')
        resource.filter_files = parse_text(xml, 'filterfiles')
      end
      parse_module(activity_dir, resource)
      resource.file_ids += parse_files(dir)
      resource
    end


    def parse_files(dir)
      files = []
      File.open(File.join(@backup_dir, dir, FILES_XML)) do |f|
        xml = Nokogiri::XML(f)
        xml.search('/inforef/fileref/file').each do |node|
          files << parse_text(node, 'id')
        end
      end
      files
    end

  end
end