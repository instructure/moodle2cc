module Moodle2CC::Moodle2::Models::Quizzes
  class QuestionCategory

    attr_accessor :id, :name, :context_id, :context_level, :context_instance_id, :info, :info_format, :stamp, :parent,
                  :sort_order, :questions


    def initialize
      @questions = []
    end

  end
end