require 'spec_helper'

module Moodle2CC::Moodle2Converter::QuestionConverters
  describe CalculatedConverter do

    it 'converts calculated questions' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.create('calculated')

      moodle_question.id = 'something'
      answer = Moodle2CC::Moodle2::Models::Quizzes::Answer.new
      answer.id = 'blah'
      moodle_question.answers = [answer]
      moodle_question.dataset_definitions = ['mock datasets']
      moodle_question.correct_answer_format = '1'
      moodle_question.correct_answer_length = '2'
      moodle_question.tolerance = '3'

      converted_question = QuestionConverter.new.convert(moodle_question)

      expect(converted_question.original_identifier).to eq moodle_question.id
      expect(converted_question.answers.count).to eq moodle_question.answers.count
      expect(converted_question.answers.first.id).to eq moodle_question.answers.first.id
      expect(converted_question.dataset_definitions).to eq moodle_question.dataset_definitions
      expect(converted_question.correct_answer_format).to eq moodle_question.correct_answer_format
      expect(converted_question.correct_answer_length).to eq moodle_question.correct_answer_length
      expect(converted_question.tolerance).to eq moodle_question.tolerance
    end

  end
end