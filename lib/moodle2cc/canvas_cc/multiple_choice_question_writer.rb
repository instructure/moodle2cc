module Moodle2CC::CanvasCC
  class MultipleChoiceQuestionWriter < QuestionWriter
    register_writer_type 'multiple_choice_question'

    private

    def self.write_responses(presentation_node, question)
      presentation_node.response_lid(:ident => 'response1', :rcardinality => 'Single') do |response_node|
        response_node.render_choice do |choice_node|
          question.answers.each do |answer|
            choice_node.response_label(:ident => answer.id) do |label_node|
              label_node.material do |material_node|
                material_node.mattext answer.answer_text, :texttype => 'text/html'
              end
            end
          end
        end
      end
    end

    def self.write_response_conditions(processing_node, question)
      # Feedback
      question.answers.each do |answer|
        next unless answer.feedback && answer.feedback.strip.length > 0
        processing_node.respcondition(:continue => 'Yes') do |condition_node|
          condition_node.conditionvar do |var_node|
            var_node.varequal answer.id, :respident => 'response1'
          end
          condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => "#{answer.id}_fb")
        end
      end

      # Scores
      question.answers.each do |answer|
        processing_node.respcondition(:continue => 'No') do |condition_node|
          condition_node.conditionvar do |var_node|
            var_node.varequal answer.id, :respident => 'response1'
          end
          condition_node.setvar(convert_fraction_to_score(answer.fraction), :varname => 'SCORE', :action => 'Set')
        end
      end
    end

    def self.write_additional_nodes(item_node, question)
      write_standard_answer_feedbacks(item_node, question)
    end
  end
end