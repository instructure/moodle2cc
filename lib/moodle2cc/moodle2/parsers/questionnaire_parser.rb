module Moodle2CC::Moodle2::Parsers
  class QuestionnaireParser
    include ParserHelper

    QUESTIONNAIRE_XML = 'questionnaire.xml'
    QUESTIONNAIRE_MODULE_NAME = 'questionnaire'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, QUESTIONNAIRE_MODULE_NAME)
      activity_dirs.map { |dir| parse_questionnaire(dir) }
    end

    private

    def parse_questionnaire(dir)
      questionnaire = Moodle2CC::Moodle2::Models::Questionnaire.new
      activity_dir = File.join(@backup_dir, dir)

      File.open(File.join(activity_dir, QUESTIONNAIRE_XML)) do |f|
        xml = Nokogiri::XML(f)
        questionnaire.id = xml.at_xpath('/activity/questionnaire/@id').value
        questionnaire.module_id = xml.at_xpath('/activity/@moduleid').value
        questionnaire.name = parse_text(xml, '/activity/questionnaire/name')
        questionnaire.intro = parse_text(xml, '/activity/questionnaire/intro')
        questionnaire.intro_format = parse_text(xml, '/activity/questionnaire/introformat')

        questionnaire.open_date = parse_text(xml, '/activity/questionnaire/opendate')
        questionnaire.close_date = parse_text(xml, '/activity/questionnaire/closedate')
        questionnaire.time_modified = parse_text(xml, '/activity/questionnaire/timemodified')

        xml.search('/activity/questionnaire/surveys/survey/questions/question').each do |node|
          question = Moodle2CC::Moodle2::Models::Questionnaire::Question.new
          question.id = node.attributes['id'].value
          question.name = parse_text(node, 'name')
          question.type_id = parse_text(node, 'type_id')
          question.position = parse_text(node, 'position')
          question.content = parse_text(node, 'content')
          question.deleted = parse_boolean(node, 'deleted')
          node.search('quest_choices/quest_choice').each do |choice_node|
            question.choices << {
              :id => choice_node.attributes['id'].value,
              :content => parse_text(choice_node, 'content')
            }
          end
          questionnaire.questions << question
        end
        questionnaire.questions.sort_by!{|q| q.position.to_i}
      end
      parse_module(activity_dir, questionnaire)

      questionnaire
    end

  end
end