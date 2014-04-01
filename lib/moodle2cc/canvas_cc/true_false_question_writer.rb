module Moodle2CC::CanvasCC
  class TrueFalseQuestionWriter < QuestionWriter

    register_writer_type 'true_false_question'

    private

    def self.write_responses(presentation_node, question)
      presentation_node.response_lid(:rcardinality => 'Single', :ident => 'response1') do |response_node|
        response_node.render_choice do |render_choice_node|
          question.answers.each do |answer|
            render_choice_node.response_label(:ident => answer.id) do |response_label_node|
              response_label_node.material do |material_node|
                material_node.mattext(answer.answer_text, :texttype => 'text/html')
              end
            end
          end
        end
      end
    end

    def self.write_response_conditions(processing_node, question)
      question.answers.each do |answer|
        processing_node.respcondition(:continue => 'No') do |condition_node|
          condition_node.conditionvar do |var_node|
            var_node.varequal answer.id, :respident => 'response1'
          end
          condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => "#{answer.id}_fb") if answer.feedback && answer.feedback.strip.length > 0
          condition_node.setvar(convert_fraction_to_score(answer.fraction), :varname => 'SCORE', :action => "Set")
        end
      end
    end

    def self.write_additional_nodes(item_node, question)
      write_standard_answer_feedbacks(item_node, question)
    end
  end
end