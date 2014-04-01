require 'spec_helper'

module Moodle2CC::Moodle2::Models::Quizzes
  describe Question do
    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :parent
    it_behaves_like 'it has an attribute for', :name
    it_behaves_like 'it has an attribute for', :question_text
    it_behaves_like 'it has an attribute for', :question_text_format
    it_behaves_like 'it has an attribute for', :general_feedback
    it_behaves_like 'it has an attribute for', :default_mark
    it_behaves_like 'it has an attribute for', :penalty
    it_behaves_like 'it has an attribute for', :qtype
    it_behaves_like 'it has an attribute for', :length
    it_behaves_like 'it has an attribute for', :stamp
    it_behaves_like 'it has an attribute for', :version
    it_behaves_like 'it has an attribute for', :hidden

    class FooBarQuestion < Question
    end

    it 'registers a question type for object creation' do
      FooBarQuestion.register_question_type 'foobar'
      expect(Question.create('foobar')).to be_instance_of FooBarQuestion
    end

    it 'raises an exception for unknown question types' do
      expect { Question.create('non_existing_question_type') }.to raise_exception
    end

    it 'creates a standard question for essay questions' do
      expect(Question.create('essay')).to be_instance_of Question
    end
  end
end