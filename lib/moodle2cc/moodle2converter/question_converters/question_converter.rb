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
    end
  end
end