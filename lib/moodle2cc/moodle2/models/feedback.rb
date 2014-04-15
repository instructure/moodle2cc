module Moodle2CC::Moodle2::Models
  class Feedback

    attr_accessor :id, :module_id, :name, :intro, :intro_format, :time_open, :time_close,
                  :time_modified, :items, :visible

    def initialize
      @items = []
    end

    class Question
      attr_accessor :id, :name, :label, :type, :position, :presentation
    end
  end
end