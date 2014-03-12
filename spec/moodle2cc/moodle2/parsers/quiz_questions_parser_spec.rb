require 'spec_helper'

module Moodle2CC::Moodle2
  describe Parsers::QuizQuestionsParser do
    subject(:parser) {Parsers::QuizQuestionsParser.new(fixture_path(File.join('moodle2', 'backup')))}

    it 'pareses quiz categories' do
      question_categories = subject.parse
      expect(question_categories.count).to eq 2
      category = question_categories.last
      expect(category).to be_instance_of Models::Quizzes::QuestionCategory
      expect(category.id).to eq '2'
      expect(category.name).to eq 'Default for SC'
      expect(category.context_id).to eq '15'
      expect(category.context_level).to eq '50'
      expect(category.context_instance_id).to eq '2'
      expect(category.info).to eq 'The default category for questions shared in context \'SC\'.'
      expect(category.info_format).to eq '0'
      expect(category.stamp).to eq '10.0.21.141+140304213555+iMFEfs'
      expect(category.parent).to eq '0'
      expect(category.sort_order).to eq '999'

      expect(category.questions.count).to eq 1

    end

    it 'parses a truefalse quiz question' do
      questions = subject.parse.last.questions
      question = questions.find {|q| q.id == '15'}
      expect(question).to be_instance_of Models::Quizzes::TrueFalseQuestion
      expect(question.id).to eq '15'
      expect(question.parent).to eq '0'
      expect(question.name).to eq 'True/False Question'
      expect(question.question_text).to eq '<p>True == True</p>'
      expect(question.question_text_format).to eq '1'
      expect(question.general_feedback).to eq '<p>feedback</p>'
      expect(question.default_mark).to eq '1.0000000'
      expect(question.penalty).to eq '1.0000000'
      expect(question.qtype).to eq 'truefalse'
      expect(question.length).to eq '1'
      expect(question.stamp).to eq '10.0.21.141+140304215800+p3jSSa'
      expect(question.version).to eq '10.0.21.141+140304215801+FQKIDE'
      expect(question.hidden).to eq false

      #expect(question.true_false_id).to eq '1'
      #expect(question.true_answer).to eq '24'
      #expect(question.false_answer).to eq '25'
    end

  end
end