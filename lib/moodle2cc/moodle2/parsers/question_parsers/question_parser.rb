module Moodle2CC::Moodle2::Parsers::QuestionParsers
  class QuestionParser

    @@subclasses = {}

    def self.parse(node)
      type = node.%('qtype').text
      if c = @@subclasses[type]
        c.new.parse_question(node)
      else
        raise "Unknown parser type: #{type}"
      end
    end

    def self.register_parser_type(name)
      @@subclasses[name] = self
    end

    def parse_common_question_attributes(node, question)

    end


  end
end