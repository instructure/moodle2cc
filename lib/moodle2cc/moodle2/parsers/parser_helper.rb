module Moodle2CC::Moodle2::Parsers
  module ParserHelper

    XML_NULL_VALUE = '$@NULL@$'

    def activity_directories(work_dir, activity_types)
      File.open(File.join(work_dir, Moodle2CC::Moodle2::Extractor::MOODLE_BACKUP_XML)) do |f|
        moodle_backup_xml = Nokogiri::XML(f)
        activities = moodle_backup_xml./('/moodle_backup/information/contents/activities').xpath("activity[modulename = '#{activity_types}']")
        activities.map { |forum| forum./('directory').text }
      end
    end

    def parse_text(node, xpath)
      if v_node = node.%(xpath)
        value = v_node.text
        value unless value == XML_NULL_VALUE
      end
    end

  end
end
