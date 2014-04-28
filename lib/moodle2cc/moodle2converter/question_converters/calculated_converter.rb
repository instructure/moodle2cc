module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class CalculatedConverter < QuestionConverter
      register_converter_type 'calculated'
      self.canvas_question_type = 'calculated_question'

      def convert_question(moodle_question)
        canvas_question = super
        canvas_question.correct_answer_format = moodle_question.correct_answer_format
        canvas_question.correct_answer_length = moodle_question.correct_answer_length
        canvas_question.dataset_definitions = moodle_question.dataset_definitions
        canvas_question.var_sets = moodle_question.var_sets
        canvas_question.tolerance = moodle_question.tolerance
        canvas_question
      end
    end
  end
end