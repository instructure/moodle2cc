module Moodle2CC::Moodle2::Models
  class Choice

    attr_accessor :id, :module_id, :name, :intro, :intro_format, :time_open, :time_close,
                  :time_modified, :publish, :show_results, :display, :allow_update, :show_unanswered,
                  :limit_answers, :completion_submit, :options, :visible

    def initialize
      @options = []
    end
  end
end