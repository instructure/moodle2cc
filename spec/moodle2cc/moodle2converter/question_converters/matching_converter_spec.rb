require 'spec_helper'

module Moodle2CC::Moodle2Converter::QuestionConverters
  describe MatchingConverter do

    it 'converts matching questions' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.create('match')
      moodle_question.id = 'something'

      moodle_question.matches = [{
        :question_text => "This is **bold** and this is _italic_",
        :question_text_format => '4',
        :answer_text => 'blah answer'
      }]

      converted_question = QuestionConverter.new.convert(moodle_question)

      expect(converted_question.identifier).to eq moodle_question.id

      expected_text = "<p>This is <strong>bold</strong> and this is <em>italic</em></p>\n"
      expect(converted_question.matches.first[:question_text]).to eq expected_text
      expect(converted_question.matches.first[:answer_text]).to eq moodle_question.matches.first[:answer_text]
    end
  end
end