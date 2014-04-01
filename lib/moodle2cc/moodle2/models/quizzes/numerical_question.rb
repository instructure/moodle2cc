module Moodle2CC::Moodle2::Models::Quizzes
  class NumericalQuestion < Question
    register_question_type 'numerical'
    attr_accessor :tolerances

    def initialize
      super
      @tolerances = {}
    end
  end
end