module Moodle2CC::Moodle2::Models
  class Questionnaire

    attr_accessor :id, :module_id, :name, :intro, :intro_format, :open_date, :close_date,
                  :time_modified, :questions, :visible

    def initialize
      @questions = []
    end

    class Question
      attr_accessor :id, :name, :type_id, :content, :position, :deleted, :choices, :precise, :length

      def initialize
        @choices = []
      end
    end
  end
end