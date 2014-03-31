module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class RandomSAConverter < QuestionConverter
      register_converter_type 'randomsamatch'

      def convert_question(moodle_question)
        canvas_group = Moodle2CC::CanvasCC::Models::QuestionGroup.new

        canvas_group.identifier = moodle_question.id
        canvas_group.title = moodle_question.name
        canvas_group.selection_number = moodle_question.choose
        canvas_group.group_type = 'random_short_answer'

        canvas_group
      end
    end
  end
end