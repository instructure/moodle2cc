module Moodle2CC::Moodle2::Parsers
  class PageParser
    include ParserHelper

    PAGE_XML = 'page.xml'
    PAGE_MODULE_NAME = 'page'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, PAGE_MODULE_NAME)
      activity_dirs.map { |dir| parse_page(dir) }
    end

    private

    def parse_page(dir)
      page = Moodle2CC::Moodle2::Models::Page.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, PAGE_XML)) do |f|
        page_xml = Nokogiri::XML(f)
        page.id = page_xml.at_xpath('/activity/page/@id').value
        page.module_id = page_xml.at_xpath('/activity/@moduleid').value
        page.name = parse_text(page_xml, '/activity/page/name')
        page.intro = parse_text(page_xml, '/activity/page/intro')
        page.intro_format = parse_text(page_xml, '/activity/page/introformat')
        page.content = parse_text(page_xml, '/activity/page/content')
        page.content_format = parse_text(page_xml, '/activity/page/contentformat')
        page.legacy_files = parse_text(page_xml, '/activity/page/legacyfiles')
        page.legacy_files_last = parse_text(page_xml, '/activity/page/legacyfileslast')
        page.display = parse_text(page_xml, '/activity/page/display')
        page.display_options = parse_text(page_xml, '/activity/page/displayoptions')
        page.revision = parse_text(page_xml, '/activity/page/revision')
        page.time_modified = parse_text(page_xml, '/activity/page/timemodified')
      end
      parse_module(activity_dir, page)

      page
    end

  end

end