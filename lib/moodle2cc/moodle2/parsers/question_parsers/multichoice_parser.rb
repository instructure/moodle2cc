module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::MultichoiceParser < Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper
    register_parser_type('multichoice')

    def parse_question(node)
      question = super

      answer_parser = Parsers::AnswerParser.new
      question.answers += node.search('answers/answer').map { |n| answer_parser.parse(n) }

      question
    end

  end
end