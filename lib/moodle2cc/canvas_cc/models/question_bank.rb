module Moodle2CC::CanvasCC::Models
  class QuestionBank

    attr_accessor :identifier, :title, :questions

    def initialize
      @questions = []
    end
  end
end