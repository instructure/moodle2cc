module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::CalculatedParser < Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper
    register_parser_type('calculated')
    register_parser_type('calculatedmulti')
    register_parser_type('calculatedsimple')

    def parse_question(node)
      question = super(node, 'calculated')

      q_node = node.at_xpath("plugin_qtype_#{question.qtype}_question")

      answer_parser = Parsers::AnswerParser.new
      question.answers += q_node.search('answers/answer').map { |n| answer_parser.parse(n) }

      if question.answers.count > 1 && question.qtype == 'calculatedmulti'
        # turn multiple choice calculated questions into standard formula questions,
        # by ignoring the incorrect formulas
        if correct_formula = question.answers.detect{|a| a.fraction == 1}
          question.answers = [correct_formula]
        end
      end

      q_node.search('dataset_definitions/dataset_definition').each do |ds_node|
        question.dataset_definitions << {
            :name => parse_text(ds_node, 'name'),
            :options => parse_text(ds_node, 'options')
        }
      end

      q_node.search('calculated_records/calculated_record').each do |cr_node|
        next unless parse_text(cr_node, 'answer') == question.answers.first.id.to_s

        question.correct_answer_format = parse_text(cr_node, 'correctanswerformat')
        question.correct_answer_length = parse_text(cr_node, 'correctanswerlength')
        question.tolerance = parse_text(cr_node, 'tolerance')
      end

      question
    end

  end
end