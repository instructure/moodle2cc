module Moodle2CC::Moodle2::Models::Quizzes
  class CalculatedQuestion < Question
    register_question_type 'calculated'
    attr_accessor :correct_answer_format, :correct_answer_length, :dataset_definitions, :tolerance, :var_sets

    def initialize
      super
      @dataset_definitions = []
      @var_sets = []
    end
  end
end