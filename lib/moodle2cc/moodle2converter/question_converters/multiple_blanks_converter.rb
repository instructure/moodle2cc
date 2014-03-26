module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class MultipleBlanksConverter < QuestionConverter
      register_converter_type 'multianswer'
      self.canvas_question_type = 'fill_in_multiple_blanks_question'

      def convert_question(moodle_question)
        canvas_question = super

        canvas_question.material.gsub!(/\[\#(\d+)\]/) do |match|
          "[response#{$1}]"
        end

        moodle_question.embedded_questions.each_with_index do |sub_question, index|
          canvas_question.answers += sub_question.answers.select{|a| a.fraction == 1}.map do |moodle_answer|
            converted_answer = Moodle2CC::CanvasCC::Models::Answer.new(moodle_answer)
            converted_answer.resp_ident = "response#{index + 1}"
            converted_answer
          end
        end

        canvas_question
      end
    end
  end
end