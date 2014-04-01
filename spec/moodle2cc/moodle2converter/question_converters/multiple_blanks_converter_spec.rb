require 'spec_helper'

module Moodle2CC::Moodle2Converter::QuestionConverters
  describe MultipleBlanksConverter do

    it 'converts multianswer questions' do
      moodle_question = Moodle2CC::Moodle2::Models::Quizzes::Question.create('multianswer')
      moodle_question.id = 'something'
      moodle_question.question_text = 'the first question is: {#1} and the second is: {#2}'

      embedded_question1 = Moodle2CC::Moodle2::Models::Quizzes::Question.create('multichoice')
      answer1 = Moodle2CC::Moodle2::Models::Quizzes::Answer.new
      answer1.id = '1'
      answer1.fraction = 1
      ignored_answer = Moodle2CC::Moodle2::Models::Quizzes::Answer.new
      ignored_answer.fraction = 0
      embedded_question1.answers = [answer1, ignored_answer]

      embedded_question2 = Moodle2CC::Moodle2::Models::Quizzes::Question.create('multichoice')
      answer2 = Moodle2CC::Moodle2::Models::Quizzes::Answer.new
      answer2.id = '2'
      answer2.fraction = 1
      embedded_question2.answers = [answer2]

      moodle_question.embedded_questions = [embedded_question1, embedded_question2]

      converted_question = QuestionConverter.new.convert(moodle_question)

      expect(converted_question.identifier).to eq moodle_question.id
      expect(converted_question.answers.count).to eq 2
      expect(converted_question.answers.detect{|a| a.id == answer1.id}.resp_ident).to eq 'response1'
      expect(converted_question.answers.detect{|a| a.id == answer2.id}.resp_ident).to eq 'response2'
      expect(converted_question.material).to eq 'the first question is: [response1] and the second is: [response2]'
    end

  end
end