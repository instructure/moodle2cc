module Moodle2CC::CanvasCC::Models
  class Answer
    attr_accessor :id, :answer_text, :answer_format, :fraction, :feedback, :feedback_format, :resp_ident

    def initialize(answer=nil)
      return unless answer
      answer.instance_variables.each do |var|
        self.instance_variable_set(var, answer.instance_variable_get(var))
      end
    end
  end
end