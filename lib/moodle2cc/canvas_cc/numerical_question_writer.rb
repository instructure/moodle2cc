module Moodle2CC::CanvasCC
  class NumericalQuestionWriter < QuestionWriter
    register_writer_type 'numerical_question'

    private

    def self.write_responses(presentation_node, question)
      presentation_node.response_str(:rcardinality => 'Single', :ident => 'response1') do |response_node|
        response_node.render_fib(:fibtype => 'Decimal') do |render_fib_node|
          render_fib_node.response_label(:ident => 'answer1')
        end
      end
    end

    def self.write_response_conditions(processing_node, question)
      question.answers.each do |answer|
        tolerance = question.tolerances[answer.id]
        processing_node.respcondition(:continue => 'No') do |condition_node|
          condition_node.conditionvar do |var_node|
            var_node.or do |or_node|
              or_node.varequal answer.answer_text, :respident => 'response1'
              or_node.and do |and_node|
                and_node.vargte answer.answer_text.to_f - tolerance.to_f, :respident => 'response1'
                and_node.varlte answer.answer_text.to_f + tolerance.to_f, :respident => 'response1'
              end
            end
          end
          condition_node.setvar(convert_fraction_to_score(answer.fraction), :varname => "SCORE", :action => 'Set')
          if answer.feedback && answer.feedback.strip.length > 0
            condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => "#{answer.id}_fb")
          end
        end
      end
    end

    def self.write_additional_nodes(item_node, question)
      write_standard_answer_feedbacks(item_node, question)
    end
  end
end