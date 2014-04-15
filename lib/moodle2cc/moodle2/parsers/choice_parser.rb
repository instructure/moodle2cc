module Moodle2CC::Moodle2::Parsers
  class ChoiceParser
    include ParserHelper

    CHOICE_XML = 'choice.xml'
    CHOICE_MODULE_NAME = 'choice'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, CHOICE_MODULE_NAME)
      activity_dirs.map { |dir| parse_choice(dir) }
    end

    private

    def parse_choice(dir)
      choice = Moodle2CC::Moodle2::Models::Choice.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, CHOICE_XML)) do |f|
        xml = Nokogiri::XML(f)
        choice.id = xml.at_xpath('/activity/choice/@id').value
        choice.module_id = xml.at_xpath('/activity/@moduleid').value
        choice.name = parse_text(xml, '/activity/choice/name')
        choice.intro = parse_text(xml, '/activity/choice/intro')
        choice.intro_format = parse_text(xml, '/activity/choice/introformat')
        
        choice.time_open = parse_text(xml, '/activity/choice/timeopen')
        choice.time_close = parse_text(xml, '/activity/choice/timeclose')
        choice.time_modified = parse_text(xml, '/activity/choice/timemodified')

        choice.publish = parse_text(xml, '/activity/choice/publish')
        choice.show_results = parse_text(xml, '/activity/choice/showresults')
        choice.display = parse_text(xml, '/activity/choice/display')
        choice.allow_update = parse_text(xml, '/activity/choice/allowupdate')
        choice.show_unanswered = parse_text(xml, '/activity/choice/showunanswered')
        choice.limit_answers = parse_text(xml, '/activity/choice/limitanswers')
        choice.completion_submit = parse_text(xml, '/activity/choice/completionsubmit')

        xml.search('/activity/choice/options/option').each do |node|
          choice.options << parse_text(node, 'text')
        end
      end
      parse_module(activity_dir, choice)

      choice
    end

  end
end