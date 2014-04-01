module Moodle2CC::Moodle2::Models::Quizzes
  class TrueFalseQuestion < Question
    register_question_type 'truefalse'
    attr_accessor :true_false_id, :true_answer, :false_answer
  end
end