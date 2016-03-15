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
      lti = Models::Lti.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, LTI_XML)) do |f|
        lti_xml = Nokogiri::XML(f)
        lti.id        = lti_xml.at_xpath('/activity/lti/@id').value
        lti.module_id = lti_xml.at_xpath('/activity/@moduleid').value
        lti.name      = parse_text(lti_xml, '/activity/lti/name')
        lti.url       = parse_text(lti_xml, '/activity/lti/toolurl')
      end
      parse_module(activity_dir, lti)
      lti
    end


  end
end