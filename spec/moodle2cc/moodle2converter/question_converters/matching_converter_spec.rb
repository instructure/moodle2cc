require 'spec_helper'

module Moodle2CC::Moodle2Converter::QuestionConverters
  describe MatchingConverter do

    it 'converts matching questions' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.create('match')
      moodle_question.id = 'something'

      moodle_question.matches = [{
        :question_text => "<p>This is a bunch of html</p>",
        :answer_text => 'blah answer'
      }]

      converted_question = QuestionConverter.new.convert(moodle_question)

      expect(converted_question.original_identifier).to eq moodle_question.id

      expected_text = "This is a bunch of html"
      expect(converted_question.matches.first[:question_text]).to include(expected_text)
      expect(converted_question.matches.first[:answer_text]).to eq moodle_question.matches.first[:answer_text]
    end
  end
end