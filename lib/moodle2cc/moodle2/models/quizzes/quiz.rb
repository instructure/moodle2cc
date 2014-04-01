module Moodle2CC::Moodle2::Models::Quizzes
  class Quiz

    attr_accessor :id, :module_id, :name, :intro, :intro_format, :time_open, :time_close,
                  :time_limit, :overdue_handling, :grace_period, :preferred_behavior,
                  :attempts_number, :attempt_on_last, :grade_method, :decimal_points,
                  :question_decimal_points, :review_attempt, :review_correctness,
                  :review_marks, :review_specific_feedback, :review_general_feedback,
                  :review_right_answer, :review_overall_feedback, :questions_per_page,
                  :nav_method, :shuffle_questions, :shuffle_answers, :sum_grades,
                  :grade, :time_created, :time_modified, :password, :subnet,
                  :browser_security, :delay1, :delay2, :show_user_picture, :show_blocks,
                  :question_instances, :feedbacks, :visible

    def initialize
      @question_instances = []
      @feedbacks = []
    end
  end
end