require 'spec_helper'

module Moodle2CC::Moodle2Converter::QuestionConverters
  describe MultichoiceConverter do

    it 'converts multiple choice questions' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.create('multichoice')
      moodle_question.id = 'something'
      moodle_question.single = true

      converted_question = QuestionConverter.new.convert(moodle_question)

      expect(converted_question.question_type).to eq 'multiple_choice_question'
    end

    it 'converts multiple answer questions' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.create('multichoice')
      moodle_question.id = 'something'
      moodle_question.single = false

      converted_question = QuestionConverter.new.convert(moodle_question)

      expect(converted_question.question_type).to eq 'multiple_answers_question'
    end
  end
end