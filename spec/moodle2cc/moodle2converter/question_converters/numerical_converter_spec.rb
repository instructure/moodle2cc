require 'spec_helper'

module Moodle2CC::Moodle2Converter::QuestionConverters
  describe NumericalConverter do

    it 'converts numerical questions' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.create('numerical')
      moodle_question.id = 'something'

      moodle_question.tolerances = [:mock_tolerances]

      converted_question = QuestionConverter.new.convert(moodle_question)

      expect(converted_question.original_identifier).to eq moodle_question.id
      expect(converted_question.tolerances).to eq moodle_question.tolerances
    end

  end
end