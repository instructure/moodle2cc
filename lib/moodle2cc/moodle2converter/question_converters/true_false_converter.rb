module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class TrueFalseConverter < QuestionConverter
      register_converter_type 'truefalse'

      def convert_question(moodle_question)
        canvas_question = Moodle2CC::CanvasCC::Model::Question.new
        canvas_question.type = 'true_false_question'
        # TODO
        canvas_question
      end
    end
  end
end