module Moodle2CC::CC
  class Question
    META_ATTRIBUTES = [:question_type, :points_possible]
    QUESTION_TYPE_MAP = {
        'calculated' =>  'calculated_question',
        'description' => 'text_only_question',
        'essay' => 'essay_question',
        'match' => 'matching_question',
        'multianswer' => 'multiple_answers_question',
        'multichoice' => 'multiple_choice_question',
        'shortanswer' => 'short_answer_question',
        'numerical' => 'numerical_question',
        'truefalse' => 'true_false_question',
      }

    attr_accessor :id, :title, *META_ATTRIBUTES

    def initialize(question_instance)
      question = question_instance.question
      @id = question.id
      @title = question.name
      @question_type = QUESTION_TYPE_MAP[question.type]
      @points_possible = question_instance.grade
    end
  end
end
