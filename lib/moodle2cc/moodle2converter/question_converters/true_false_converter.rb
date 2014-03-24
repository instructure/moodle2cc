module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class TrueFalseConverter < QuestionConverter
      register_converter_type 'truefalse'
      self.canvas_question_type = 'true_false_question'

      def convert_question(moodle_question)
        moodle_question.answers = moodle_question.answers.select{|a|
          [moodle_question.true_answer.to_s, moodle_question.false_answer.to_s].include?(a.id.to_s)
        }.map do |a|
          a.fraction = (moodle_question.true_answer.to_s == a.id.to_s) ? 1.0 : 0.0
          a
        end

        canvas_question = super(moodle_question)
        canvas_question
      end
    end
  end
end