module Moodle2CC::Moodle2
  class Parsers::QuestionParsers::MatchParser < Parsers::QuestionParsers::QuestionParser
    include Parsers::ParserHelper
    register_parser_type('match')
    register_parser_type('ddmatch')

    def parse_question(node)
      question = super(node, 'match')

      q_node = node.at_xpath("plugin_qtype_#{question.qtype}_question")

      q_node.search('matches/match').each do |m_node|
        question.matches << {
          :id => m_node.attributes['id'].value,
          :question_text => parse_text(m_node, 'questiontext'),
          :question_text_format => parse_text(m_node, 'questiontextformat'),
          :answer_text => parse_text(m_node, 'answertext')
        }
      end

      question
    end

  end
end