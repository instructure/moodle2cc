module Moodle2CC::Moodle2::Parsers
  class FolderParser
    include ParserHelper

    FOLDER_MODULE_NAME = 'folder'
    FOLDER_XML = 'folder.xml'
    FILES_XML = 'inforef.xml'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, FOLDER_MODULE_NAME)
      activity_dirs.map { |dir| parse_folder(dir) }
    end

    private

    def parse_folder(dir)
      folder = Moodle2CC::Moodle2::Models::Folder.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, FOLDER_XML)) do |f|
        xml = Nokogiri::XML(f)
        folder.module_id = xml.at_xpath('/activity/@moduleid').value
        folder.id = xml.at_xpath('/activity/folder/@id').value
        folder.name = parse_text(xml, '/activity/folder/name')
        folder.intro = parse_text(xml, '/activity/folder/intro')
        folder.intro_format = parse_text(xml, '/activity/folder/introformat')
        folder.revision = parse_text(xml, '/activity/folder/revision')

        #xml.search('/activity/book/chapters/chapter').each do |node|
        #  book.chapters << parse_chapter(node)
        #end
      end
      parse_module(activity_dir, folder)

      folder.file_ids += parse_files(dir)
      folder
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