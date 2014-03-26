module Moodle2CC::Moodle2::Parsers
  module QuestionParsers
    require_relative 'question_parsers/question_parser'
    require_relative 'question_parsers/calculated_parser'
    require_relative 'question_parsers/multianswer_parser'
    require_relative 'question_parsers/multichoice_parser'
    require_relative 'question_parsers/short_answer_parser'
    require_relative 'question_parsers/true_false_parser'
  end
end