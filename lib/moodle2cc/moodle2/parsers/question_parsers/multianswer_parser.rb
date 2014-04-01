module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::MultianswerParser < Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper
    register_parser_type('multianswer')

    def parse_question(node)
      question = super

      answer_parser = Parsers::AnswerParser.new
      question.answers += node.search('answers/answer').map { |n| answer_parser.parse(n) }


      if sequence = node.at_xpath('plugin_qtype_multianswer_question/multianswer/sequence')
        question.embedded_question_references = sequence.text.split(',')
      end

      question
    end

  end
end