require 'spec_helper'

module Moodle2CC::Moodle2::Models::Quizzes
  describe TrueFalseQuestion do

    it_behaves_like 'a Moodle2CC::Moodle2::Models::Quizzes::Question'

    it_behaves_like 'it has an attribute for', :true_false_id
    it_behaves_like 'it has an attribute for', :true_answer
    it_behaves_like 'it has an attribute for', :false_answer

    it_behaves_like 'it is registered as a Question', 'truefalse'


  end
end