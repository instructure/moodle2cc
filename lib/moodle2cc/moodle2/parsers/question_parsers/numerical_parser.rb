module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::NumericalParser < Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper
    register_parser_type('numerical')

    def parse_question(node)
      question = super

      q_node = node.at_xpath("plugin_qtype_#{question.qtype}_question")

      answer_parser = Parsers::AnswerParser.new
      question.answers += q_node.search('answers/answer').map { |n| answer_parser.parse(n) }

      q_node.search('numerical_records/numerical_record').each do |nr_node|
        answer_id = parse_text(nr_node, 'answer')
        tolerance = parse_text(nr_node, 'tolerance')
        question.tolerances[answer_id] = tolerance
      end

      question
    end

  end
end