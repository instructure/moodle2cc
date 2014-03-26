module Moodle2CC::Moodle2::Models::Quizzes
  class QuestionCategory

    attr_accessor :id, :name, :context_id, :context_level, :context_instance_id, :info, :info_format, :stamp, :parent,
                  :sort_order, :questions


    def initialize
      @questions = []
    end

    def resolve_embedded_question_references(question_categories)
      @questions.select{|q| q.is_a?(MultianswerQuestion)}.each do |q|
        q.resolve_embedded_question_references(question_categories)
      end
    end
  end
end