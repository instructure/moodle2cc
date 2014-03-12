module Moodle2CC::Moodle2::Models::Quizzes
  class Question

    @@subclasses = {}

    def self.create(type)
      if c = @@subclasses[type]
        c.new
      else
        raise "Unknown question type: #{type}"
      end
    end

    def self.register_question_type(name)
      @@subclasses[name] = self
    end

    attr_accessor :id, :parent, :name, :question_text, :question_text_format, :general_feedback, :default_mark,
                  :penalty, :qtype, :length, :stamp, :version, :hidden, :answers

    def initialize
      @answers = []
    end
  end
end