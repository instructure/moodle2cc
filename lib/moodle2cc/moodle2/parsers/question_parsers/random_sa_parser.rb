module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::RandomSAParser < Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper
    register_parser_type('randomsamatch')

    def parse_question(node)
      question = super

      if choose_node = node.at_xpath("plugin_qtype_randomsamatch_question/randomsamatch/choose")
        question.choose = choose_node.text
      end

      question
    end

  end
end