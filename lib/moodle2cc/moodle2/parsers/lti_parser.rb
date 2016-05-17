require 'byebug'
module Moodle2CC::Moodle2
  class Parsers::LtiParser
    include Parsers::ParserHelper

    LTI_XML = 'lti.xml'
    LTI_MODULE_NAME = 'lti'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, LTI_MODULE_NAME)
      activity_dirs.map { |dir| parse_lti(dir) }
    end

    private

    def parse_lti(dir)
      model = nil
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, LTI_XML)) do |f|
        lti_xml = Nokogiri::XML(f)
        points = parse_text(lti_xml, '/activity/lti/grade')
        if points && points.to_i > 0
          model = Models::Assignment.new
          model.id        = lti_xml.at_xpath('/activity/lti/@id').value
          model.module_id = lti_xml.at_xpath('/activity/@moduleid').value
          model.name      = parse_text(lti_xml, '/activity/lti/name')
          model.intro     = parse_text(lti_xml, "/activity/lti/intro")
          model.intro_format = parse_text(lti_xml, "/activity/lti/introformat")
          model.grade     = points
          model.external_tool_url = parse_text(lti_xml, '/activity/lti/toolurl')
        else
          model = Models::Lti.new
          model.id        = lti_xml.at_xpath('/activity/lti/@id').value
          model.module_id = lti_xml.at_xpath('/activity/@moduleid').value
          model.name      = parse_text(lti_xml, '/activity/lti/name')
          model.url       = parse_text(lti_xml, '/activity/lti/toolurl')
        end
      end
      parse_module(activity_dir, model)
      model
    end


  end
end