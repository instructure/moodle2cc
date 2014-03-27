module Moodle2CC::Moodle2
  class Parsers::LabelParser
    include Parsers::ParserHelper

    LABEL_XML = 'label.xml'
    LABEL_MODULE_NAME = 'label'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, LABEL_MODULE_NAME)
      activity_dirs.map { |dir| parse_label(dir) }
    end

    private

    def parse_label(glossary_dir)
      label = Models::Label.new
      File.open(File.join(@backup_dir, glossary_dir, LABEL_XML)) do |f|
        label_xml = Nokogiri::XML(f)
        label.id = label_xml.at_xpath('/activity/label/@id').value
        label.module_id = label_xml.at_xpath('/activity/@moduleid').value
        label.name = parse_text(label_xml, '/activity/label/name')
        label.intro = parse_text(label_xml, '/activity/label/intro')
        label.intro_format = parse_text(label_xml, '/activity/label/introformat')
      end
      label
    end


  end
end