module Moodle2CC::CanvasCC::Models
  class MatchingQuestion < Question
    register_question_type 'matching_question'

    attr_accessor :matches
  end
end