module Moodle2CC::Moodle2::Parsers
  class ExternalUrlParser
    include ParserHelper

    URL_MODULE_NAME = 'url'
    URL_XML = 'url.xml'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, URL_MODULE_NAME)
      activity_dirs.map { |dir| parse_folder(dir) }
    end

    private

    def parse_folder(dir)
      external_url = Moodle2CC::Moodle2::Models::ExternalUrl.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, URL_XML)) do |f|
        xml = Nokogiri::XML(f)
        external_url.module_id = xml.at_xpath('/activity/@moduleid').value
        external_url.id = xml.at_xpath('/activity/url/@id').value
        external_url.name = parse_text(xml, '/activity/url/name')
        external_url.intro = parse_text(xml, '/activity/url/intro')
        external_url.intro_format = parse_text(xml, '/activity/url/introformat')
        external_url.external_url = parse_text(xml, '/activity/url/externalurl')
        external_url.display = parse_text(xml, '/activity/url/display')
        external_url.display_options = parse_text(xml, '/activity/url/displayoptions')
        external_url.parameters = parse_text(xml, '/activity/url/parameters')
      end
      parse_module(activity_dir, external_url)

      external_url
    end

  end
end