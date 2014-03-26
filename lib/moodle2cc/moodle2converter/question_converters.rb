module Moodle2CC::Moodle2Converter
  module QuestionConverters
    require_relative 'question_converters/question_converter'
    require_relative 'question_converters/calculated_converter'
    require_relative 'question_converters/multiple_blanks_converter'
    require_relative 'question_converters/true_false_converter'
  end
end