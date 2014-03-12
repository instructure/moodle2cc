module Moodle2CC::Moodle2
  class Parsers::AnswerParser
    include Parsers::ParserHelper

    def parse(node)
      answer = Models::Quizzes::Answer.new
      answer.id = node.at_xpath('@id').value
      answer.answer_text = parse_text(node, 'answertext')
      answer.fraction = parse_text(node, 'fraction')
      answer.feedback = parse_text(node, 'feedback')
      answer.feedback_format = parse_text(node, 'feedbackformat')

      answer
    end

  end
end