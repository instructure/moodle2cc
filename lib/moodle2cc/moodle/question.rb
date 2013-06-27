module Moodle2CC::Moodle
  class Question
    include HappyMapper

    attr_accessor :question_category, :grade, :instance_id

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

    class Match
      include HappyMapper

      tag 'MATCHS/MATCH'
      element :id, Integer, :tag => 'ID'
      element :code, Integer, :tag => 'CODE'
      element :question_text, String, :tag => 'QUESTIONTEXT'
      element :answer_text, String, :tag => 'ANSWERTEXT'
    end

    class Numerical
      include HappyMapper

      tag 'NUMERICAL'
      element :answer_id, Integer, :tag => 'ANSWER'
      element :tolerance, Integer, :tag => 'TOLERANCE'
    end

    class Choice
      include HappyMapper

      tag 'QUESTION_CHOICE'
      element :id, Integer, :tag => 'ID'
      element :content, String, :tag => 'CONTENT'
    end

    tag 'QUESTION'
    element :id, Integer, :tag => 'ID'
    element :name, String, :tag => 'NAME'
    element :text, String, :tag => 'QUESTIONTEXT'
    element :format, Integer, :tag => 'QUESTIONTEXTFORMAT'
    element :content, String, :tag => 'CONTENT'
    element :length, Integer, :tag => 'LENGTH'
    element :general_feedback, String, :tag => 'GENERALFEEDBACK'
    element :default_grade, Integer, :tag => 'DEFAULTGRADE'
    element :position, Integer, :tag => 'POSITION'
    element :type, String, :tag => 'QTYPE'
    element :type_id, Integer, :tag => 'TYPE_ID'
    element :image, String, :tag => 'IMAGE'
    has_many :numericals, Numerical
    has_many :answers, Answer
    has_many :calculations, Calculation
    has_many :matches, Match
    has_many :choices, Choice

    def instance
      question_category.course.mods.select do |mod|
        mod.mod_type == 'quiz'
      end.map do |mod|
        mod.question_instances.find do |qi|
          qi.question_id == id
        end
      end.compact.first
    end
  end
end
