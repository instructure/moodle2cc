module Moodle2CC::Moodle
  class QuestionCategory
    include HappyMapper

    tag 'QUESTION_CATEGORIES/QUESTION_CATEGORY'
    element :id, Integer, :tag => 'ID'
    element :name, String, :tag => 'NAME'
    element :info, String, :tag => 'INFO'
    has_many :questions, Question
  end
end
