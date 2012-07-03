module Moodle2CC::Moodle
  class Question
    include HappyMapper

    class Answer
      include HappyMapper

      tag 'ANSWERS/ANSWER'
      element :id, Integer, :tag => 'ID'
      element :text, String, :tag => 'ANSWER_TEXT'
      element :fraction, Float, :tag => 'FRACTION'
      element :feedback, String, :tag => 'FEEDBACK'
    end

    class Calculation
      include HappyMapper

      class DatasetDefinition
        include HappyMapper

        class DatasetItem
          include HappyMapper

          tag 'DATASET_ITEMS/DATASET_ITEM'
          element :number, Integer, :tag => 'NUMBER'
          element :value, Float, :tag => 'VALUE'
        end

        tag 'DATASET_DEFINITIONS/DATASET_DEFINITION'
        element :name, String, :tag => 'NAME'
        element :options, String, :tag => 'OPTIONS'
        has_many :dataset_items, DatasetItem
      end

      tag 'CALCULATED'
      element :answer_id, Integer, :tag => 'ANSWER'
      element :tolerance, Float, :tag => 'TOLERANCE'
      element :correct_answer_length, Integer, :tag => 'CORRECTANSWERLENGTH'
      element :correct_answer_format, Integer, :tag => 'CORRECTANSWERFORMAT'
      has_many :dataset_definitions, DatasetDefinition
    end

    tag 'QUESTIONS/QUESTION'
    element :id, Integer, :tag => 'ID'
    element :name, String, :tag => 'NAME'
    element :question_text, String, :tag => 'QUESTIONTEXT'
    element :general_feedback, String, :tag => 'GENERALFEEDBACK'
    element :default_grade, Integer, :tag => 'DEFAULTGRADE'
    element :type, String, :tag => 'QTYPE'
    has_many :answers, Answer
    has_many :calculations, Calculation
  end
end
