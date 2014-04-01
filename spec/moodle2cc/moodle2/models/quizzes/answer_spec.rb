require 'spec_helper'

module Moodle2CC::Moodle2::Models::Quizzes
  describe Answer do

    it_behaves_like 'it has an attribute for', :id
    it_behaves_like 'it has an attribute for', :answer_text
    it_behaves_like 'it has an attribute for', :answer_format
    it_behaves_like 'it has an attribute for', :fraction
    it_behaves_like 'it has an attribute for', :feedback
    it_behaves_like 'it has an attribute for', :feedback_format

  end
end