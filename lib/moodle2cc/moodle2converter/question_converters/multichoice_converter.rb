module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class MultichoiceConverter < QuestionConverter
      register_converter_type 'multichoice'

      def create_canvas_question(question_type, moodle_question)
        if moodle_question.single
          Moodle2CC::CanvasCC::Models::Question.create('multiple_choice_question')
        else
          Moodle2CC::CanvasCC::Models::Question.create('multiple_answers_question')
        end
      end
    end
  end
end