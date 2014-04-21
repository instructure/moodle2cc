module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::MultichoiceParser < Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper
    register_parser_type('multichoice')

    def parse_question(node)
      question = super

      answer_parser = Parsers::AnswerParser.new
      question.answers += node.search('answers/answer').map { |n| answer_parser.parse(n) }

      question.single = parse_boolean(node, 'plugin_qtype_multichoice_question/multichoice/single')

      question
    end

  end
end