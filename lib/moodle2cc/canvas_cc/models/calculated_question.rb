module Moodle2CC::CanvasCC::Models
  class CalculatedQuestion < Question
    register_question_type 'calculated_question'

    attr_accessor :correct_answer_format, :correct_answer_length, :dataset_definitions, :tolerance
  end
end