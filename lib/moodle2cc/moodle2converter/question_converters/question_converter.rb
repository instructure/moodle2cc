module Moodle2CC::Moodle2Converter
  module QuestionConverters
    class QuestionConverter
      class << self
        attr_accessor :canvas_question_type
      end

      @@subclasses = {}
      def self.register_converter_type(name)
        @@subclasses[name] = self
      end

      STANDARD_CONVERSIONS = {'essay' => 'essay_question', 'shortanswer' => 'short_answer_question'}

      def convert(moodle_question)
        type = moodle_question.type
        if type && c = @@subclasses[type]
          c.new.convert_question(moodle_question)
        elsif type && question_type = STANDARD_CONVERSIONS[type]
          self.convert_question(moodle_question, question_type)
        else
          raise "Unknown converter type: #{type}"
        end
      end

      def convert_question(moodle_question, question_type = nil)
        canvas_question = create_canvas_question(question_type)
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

      def create_canvas_question(question_type = nil)
        question_type ||= self.class.canvas_question_type
        raise 'set canvas_question_type in question converter subclasses' unless question_type
        Moodle2CC::CanvasCC::Models::Question.create(question_type)
      end
    end
  end
end