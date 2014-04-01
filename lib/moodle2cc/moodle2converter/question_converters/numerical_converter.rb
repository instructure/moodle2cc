module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class NumericalConverter < QuestionConverter
      register_converter_type 'numerical'
      self.canvas_question_type = 'numerical_question'

      def convert_question(moodle_question)
        canvas_question = super
        canvas_question.tolerances = moodle_question.tolerances
        canvas_question
      end
    end
  end
end