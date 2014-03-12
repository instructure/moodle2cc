module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::TrueFalseParser < Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper
    register_parser_type('truefalse')

    def parse_question(node)
      question = super
      q_node = node.at_xpath('plugin_qtype_truefalse_question')
      question.true_false_id = q_node.at_xpath('truefalse/@id').value
      question.true_answer = parse_text(q_node, 'truefalse/trueanswer')
      question.false_answer = parse_text(q_node, 'truefalse/falseanswer')

      answer_parser = Parsers::AnswerParser.new
      question.answers += node.search('answers/answer').map { |n| answer_parser.parse(n) }

      question
    end

  end
end