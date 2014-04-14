module Moodle2CC::CanvasCC::Models
  class Question
    QTI_META_ATTRIBUTES = [:question_type, :points_possible, :assessment_question_identifierref]
    STANDARD_QUESTION_TYPES = ['essay_question', 'fill_in_multiple_blanks_question',
                               'multiple_choice_question', 'multiple_answers_question',
                               'short_answer_question', 'text_only_question', 'true_false_question']

    attr_accessor :identifier, :original_identifier, :title, :material, :answers, :general_feedback, *QTI_META_ATTRIBUTES

    @@subclasses = {}

    def self.create(type)
      q = if STANDARD_QUESTION_TYPES.include?(type)
        self.new
      elsif c = @@subclasses[type]
        c.new
      else
        raise "Unknown question type: #{type}"
      end
      q.question_type = type
      q
    end

    def self.register_question_type(name)
      @@subclasses[name] = self
    end

    def initialize
      @answers = []
    end
  end
end

require_relative 'calculated_question'
require_relative 'matching_question'
require_relative 'numerical_question'