require 'spec_helper'

module Moodle2CC::Moodle2::Models::Quizzes
  describe MultianswerQuestion do

    it_behaves_like 'a Moodle2CC::Moodle2::Models::Quizzes::Question'

    it_behaves_like 'it has an attribute for', :embedded_question_references
    it_behaves_like 'it has an attribute for', :embedded_questions

    it_behaves_like 'it is registered as a Question', 'multianswer'

    it 'should resolve embedded question references and remove them from their categories' do
      parent_question = Moodle2CC::Moodle2::Models::Quizzes::MultianswerQuestion.new
      parent_question.id = "immaparent"
      parent_question.embedded_question_references = ['embedme']

      embedded_question = Moodle2CC::Moodle2::Models::Quizzes::Question.new
      embedded_question.id = 'embedme'
      embedded_question.parent = 'immaparent'

      category = Moodle2CC::Moodle2::Models::Quizzes::QuestionCategory.new
      category.questions = [parent_question, embedded_question]

      parent_question.resolve_embedded_question_references([category])
      expect(parent_question.embedded_questions).to eq [embedded_question]
      expect(category.questions).to eq [parent_question]
    end
  end
end