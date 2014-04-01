require 'spec_helper'

module Moodle2CC::Moodle2::Models::Quizzes
  describe QuestionCategory do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :name
    it_behaves_like 'it has an attribute for', :context_id
    it_behaves_like 'it has an attribute for', :context_level
    it_behaves_like 'it has an attribute for', :context_instance_id
    it_behaves_like 'it has an attribute for', :info
    it_behaves_like 'it has an attribute for', :info_format
    it_behaves_like 'it has an attribute for', :stamp
    it_behaves_like 'it has an attribute for', :parent
    it_behaves_like 'it has an attribute for', :sort_order
    it_behaves_like 'it has an attribute for', :questions, []

    it 'should pass resolve_embedded_question_references to multianswer questions' do
      question = Moodle2CC::Moodle2::Models::Quizzes::MultianswerQuestion.new
      question.stub(:resolve_embedded_question_references)

      category = Moodle2CC::Moodle2::Models::Quizzes::QuestionCategory.new
      category.questions = [question]

      category.resolve_embedded_question_references([])
      expect(question).to have_received(:resolve_embedded_question_references).exactly(1)
    end
  end
end