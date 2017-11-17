require 'spec_helper'

module Moodle2CC::Moodle2Converter::QuestionConverters
  describe RandomSAConverter do

    it 'converts random short answer questions into question groups' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.create('randomsamatch')
      moodle_question.id = 'something'
      moodle_question.name = 'soemthing else '
      moodle_question.choose = '2'

      converted_group = QuestionConverter.new.convert(moodle_question)

      expect(converted_group.is_a?(Moodle2CC::CanvasCC::Models::QuestionGroup)).to be_truthy
      expect(converted_group.identifier).to eq moodle_question.id
      expect(converted_group.title).to eq moodle_question.name
      expect(converted_group.selection_number).to eq moodle_question.choose
    end
  end
end