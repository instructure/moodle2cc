module Moodle2CC::CanvasCC
  class MultipleBlanksQuestionWriter < QuestionWriter
    register_writer_type 'fill_in_multiple_blanks_question'

    private

    def self.write_responses(presentation_node, question)
      resp_idents = question.answers.map{|a| a.resp_ident}.uniq
      resp_idents.each do |resp_ident|
        presentation_node.response_lid(:ident => resp_ident, :rcardinality => 'Single') do |response_node|
          response_node.render_choice do |choice_node|
            question.answers.select{|a| a.resp_ident == resp_ident}.each do |answer|
              choice_node.response_label(:ident => answer.id) do |label_node|
                label_node.material do |material_node|
                  material_node.mattext answer.answer_text, :texttype => 'text/html'
                end
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
            var_node.varequal answer.id, :respident => answer.resp_ident
          end
          condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => "#{answer.id}_fb")
        end
      end

      # Scores
      question.answers.each do |answer|
        processing_node.respcondition(:continue => 'No') do |condition_node|
          condition_node.conditionvar do |var_node|
            var_node.varequal answer.id, :respident => answer.resp_ident
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