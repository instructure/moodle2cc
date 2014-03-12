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
  end
end