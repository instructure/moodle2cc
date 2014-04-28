module Moodle2CC::CanvasCC::Models
  class MultipleDropdownsQuestion < Question
    register_question_type 'multiple_dropdowns_question'

    attr_accessor :responses
  end
end