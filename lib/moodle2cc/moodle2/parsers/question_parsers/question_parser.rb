module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper

    @@subclasses = {}

    def self.parse(node)
      type = node.%('qtype').text
      if c = @@subclasses[type]
        c.new.parse_question(node)
      else
        raise "Unknown parser type: #{type}"
      end
    end

    def self.register_parser_type(name)
      @@subclasses[name] = self
    end

    # simple question types
    register_parser_type('description')
    register_parser_type('essay')
    register_parser_type('random')

    def parse_question(node, question_type = nil)
      begin
        question_type ||= parse_text(node, 'qtype')
        question = Models::Quizzes::Question.create question_type

        question.id = node.at_xpath('@id').value
        question.parent = parse_text(node, 'parent')
        question.name = parse_text(node, 'name')
        question.question_text = parse_text(node, 'questiontext')
        question.question_text_format = parse_text(node, 'questiontextformat')
        question.general_feedback = parse_text(node, 'generalfeedback')
        question.default_mark = parse_text(node, 'defaultmark')
        question.max_mark = parse_text(node, 'maxmark')
        question.penalty = parse_text(node, 'penalty')
        question.qtype = parse_text(node, 'qtype')
        question.length = parse_text(node, 'length')
        question.stamp = parse_text(node, 'stamp')
        question.version = parse_text(node, 'version')
        question.hidden = parse_boolean(node, 'hidden')

        question
      rescue Exception => e
        Moodle2CC::OutputLogger.logger.info e.message
        nil
      end
    end


  end
end
