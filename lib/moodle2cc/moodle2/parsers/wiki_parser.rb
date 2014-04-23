module Moodle2CC::Moodle2::Parsers
  class WikiParser
    include ParserHelper

    WIKI_XML = 'wiki.xml'
    WIKI_MODULE_NAME = 'wiki'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, WIKI_MODULE_NAME)
      activity_dirs.map { |dir| parse_wiki(dir) }
    end

    private

    def parse_wiki(dir)
      wiki = Moodle2CC::Moodle2::Models::Wiki.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, WIKI_XML)) do |f|
        wiki_xml = Nokogiri::XML(f)
        wiki.id = wiki_xml.at_xpath('/activity/wiki/@id').value
        wiki.module_id = wiki_xml.at_xpath('/activity/@moduleid').value
        wiki.name = parse_text(wiki_xml, '/activity/wiki/name')
        wiki.intro = parse_text(wiki_xml, '/activity/wiki/intro')
        wiki.intro_format = parse_text(wiki_xml, '/activity/wiki/introformat')

        wiki.first_page_title = parse_text(wiki_xml, '/activity/wiki/firstpagetitle')

        wiki_xml.search('/activity/wiki/subwikis/subwiki/pages/page').each do |node|
          wiki.pages << {
            :id => node.attributes['id'].value,
            :title => parse_text(node, 'title'),
            :content => parse_text(node, 'cachedcontent')
          }
        end
      end
      parse_module(activity_dir, wiki)

      wiki
    end

  end

end