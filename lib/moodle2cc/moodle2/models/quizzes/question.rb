module Moodle2CC::Moodle2::Models::Quizzes
  class Question

    @@subclasses = {}

    STANDARD_TYPES = ['description', 'essay', 'random', 'shortanswer']

    def self.create(type)
      if c = @@subclasses[type]
        q = c.new
        q.type = type
        q
      elsif STANDARD_TYPES.include?(type)
        q = self.new
        q.type = type
        q
      else
        raise "Unknown question type: #{type}"
      end
    end

    def self.register_question_type(name)
      @@subclasses[name] = self
    end

    attr_accessor :id, :bank_entry_id, :parent, :name, :question_text, :question_text_format, :general_feedback, :default_mark, :max_mark,
                  :penalty, :qtype, :length, :stamp, :version, :hidden, :answers, :type

    def initialize
      @answers = []
    end
  end
end
