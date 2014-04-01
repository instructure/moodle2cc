module Moodle2CC::Moodle2::Models::Quizzes
  class MatchQuestion < Question
    register_question_type 'match'
    attr_accessor :matches

    def initialize
      super
      @matches = []
    end
  end
end