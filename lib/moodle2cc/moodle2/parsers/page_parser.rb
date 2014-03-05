module Moodle2CC::Moodle2::Parser
  class PageParser

    PAGE_XML = 'page.xml'
    NULL_XML_VALUE = '$@NULL@$'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = parse_moodle_backup
      activity_dirs.map { |dir| parse_page(dir) }
    end


    private

    def parse_moodle_backup
      File.open(File.join(@backup_dir, Moodle2CC::Moodle2::Extractor::MOODLE_BACKUP_XML)) do |f|
        moodle_backup_xml = Nokogiri::XML(f)
        activities = moodle_backup_xml./('/moodle_backup/information/contents/activities').xpath('activity[modulename = "page"]')
        activities.map { |page| page./('directory').text }
      end
    end

    def parse_page(page_dir)
      page = Moodle2CC::Moodle2::Models::Page.new
      File.open(File.join(@backup_dir, page_dir, PAGE_XML)) do |f|
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
      page
    end

    def parse_text(node, xpath)
      if v_node = node.%(xpath)
        value = v_node.text
        value unless value == NULL_XML_VALUE
      end
    end

  end

end