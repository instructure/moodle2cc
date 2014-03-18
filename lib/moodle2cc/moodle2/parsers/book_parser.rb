module Moodle2CC::Moodle2::Parsers
  class BookParser
    include ParserHelper

    BOOK_MODULE_NAME = 'book'
    BOOK_XML = 'book.xml'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, BOOK_MODULE_NAME)
      activity_dirs.map { |dir| parse_book(dir) }
    end

    private
    def parse_book(dir)
      book = Moodle2CC::Moodle2::Models::Book.new
      File.open(File.join(@backup_dir, dir, BOOK_XML)) do |f|
        xml = Nokogiri::XML(f)
        book.module_id = xml.at_xpath('/activity/@moduleid').value
        book.id = xml.at_xpath('/activity/book/@id').value
        book.name = parse_text(xml, '/activity/book/name')
        book.intro = parse_text(xml, '/activity/book/intro')
        book.intro_format = parse_text(xml, '/activity/book/introformat')
        book.numbering = parse_text(xml, '/activity/book/numbering')
        book.custom_titles = parse_text(xml, '/activity/book/customtitles')

        xml.search('/activity/book/chapters/chapter').each do |node|
          book.chapters << parse_chapter(node)
        end
      end
      book
    end

    def parse_chapter(node)
      chapter = Moodle2CC::Moodle2::Models::BookChapter.new
      chapter.id = node.at_xpath('@id').value
      chapter.pagenum = parse_text(node, 'pagenum')
      chapter.subchapter = parse_boolean(node, 'subchapter')
      chapter.title = parse_text(node, 'title')
      chapter.content = parse_text(node, 'content')
      chapter.content_format = parse_text(node, 'contentformat')
      chapter.hidden = parse_boolean(node, 'hidden') == '1' ? true : false
      chapter
    end
  end
end