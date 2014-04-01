require 'spec_helper'

module Moodle2CC::Moodle2::Models::Quizzes
  describe CalculatedQuestion do

    it_behaves_like 'a Moodle2CC::Moodle2::Models::Quizzes::Question'

    it_behaves_like 'it has an attribute for', :correct_answer_format
    it_behaves_like 'it has an attribute for', :correct_answer_length
    it_behaves_like 'it has an attribute for', :tolerance

    it_behaves_like 'it is registered as a Question', 'calculated'
  end
end