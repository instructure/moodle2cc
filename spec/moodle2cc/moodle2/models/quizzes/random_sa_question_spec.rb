require 'spec_helper'

module Moodle2CC::Moodle2::Models::Quizzes
  describe RandomSAQuestion do

    it_behaves_like 'a Moodle2CC::Moodle2::Models::Quizzes::Question'

    it_behaves_like 'it has an attribute for', :choose

    it_behaves_like 'it is registered as a Question', 'randomsamatch'
  end
end