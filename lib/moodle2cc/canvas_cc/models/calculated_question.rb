module Moodle2CC::CanvasCC::Models
  class CalculatedQuestion < Question
    register_question_type 'calculated_question'

    attr_accessor :correct_answer_format, :correct_answer_length, :dataset_definitions, :tolerance, :var_sets

    def post_process!
      @material.gsub!(/\{([\w\s]*?)\}/, '[\1]') if @material

      return unless @answers
      @answers.each do |answer|
        if answer.answer_text
          answer.answer_text.gsub!(/\{([\w\s]*?)\}/, '\1')
          answer.answer_text = answer.answer_text.sub('=', '') if answer.answer_text.start_with?('=')
        end
      end
    end
  end
end