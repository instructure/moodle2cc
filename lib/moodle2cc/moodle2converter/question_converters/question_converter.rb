module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class QuestionConverter
      @@subclasses = {}

      def self.register_converter_type(name)
        @@subclasses[name] = self
      end

      def convert(moodle_question)
        type = moodle_question.type
        if type && c = @@subclasses[type]
          c.new.convert_question(moodle_question)
        else
          raise "Unknown converter type: #{type}"
        end
      end

      def convert_question(moodle_question)
        canvas_question = create_canvas_question
        canvas_question.identifier = moodle_question.id
        canvas_question.title = moodle_question.name
        canvas_question.general_feedback = moodle_question.general_feedback
        canvas_question.answers = moodle_question.answers
        canvas_question.material = convert_question_text(moodle_question)
        canvas_question
      end

      def convert_question_text(moodle_question)
        material = moodle_question.question_text || ''
        material = material.gsub(/\{(.*?)\}/, '[\1]')
        material = RDiscount.new(material).to_html if moodle_question.question_text_format.to_i == 4 # markdown
        material
      end

      def create_canvas_question
        raise 'implement in question converter subclasses'
      end
    end
  end
end