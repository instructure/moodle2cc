module Moodle2CC::Moodle
  class QuestionCategory
    include HappyMapper

    attr_accessor :course

    tag 'QUESTION_CATEGORIES/QUESTION_CATEGORY'
    element :id, Integer, :tag => 'ID'
    element :name, String, :tag => 'NAME'
    element :info, String, :tag => 'INFO'
    has_many :questions, Question

    after_parse do |qc|
      qc.questions.each { |q| q.question_category = qc }
    end
  end
end
