module Moodle2CC::CanvasCC
  class MatchingQuestionWriter < QuestionWriter
    register_writer_type 'matching_question'

    private

    def self.write_responses(presentation_node, question)
      question.matches.each do |match|
        presentation_node.response_lid(:ident => "response_#{match[:id]}") do |response_node|
          next unless match[:question_text].length > 0
          response_node.material do |material_node|
            material_node.mattext(match[:question_text], :texttype => ((match[:question_text_format].to_i == 1) ? 'text/html' : 'text/plain'))
          end
          response_node.render_choice do |choice_node|
            question.matches.each do |possible_match|
              choice_node.response_label(:ident => possible_match[:id]) do |label_node|
                label_node.material do |material_node|
                  material_node.mattext(possible_match[:answer_text], :texttype => ((match[:answer_text_format].to_i == 1) ? 'text/html' : 'text/plain'))
                end
              end
            end
          end
        end
      end
    end

    def self.write_response_conditions(processing_node, question)
      real_matches = question.matches.select{|m| m[:question_text].length > 0}
      score = 100.0 / real_matches.length.to_i
      real_matches.each do |match|
        processing_node.respcondition do |condition_node|
          condition_node.conditionvar do |var_node|
            var_node.varequal match[:id], :respident => "response_#{match[:id]}"
          end
          condition_node.setvar "%.2f" % score, :varname => 'SCORE', :action => 'Add'
        end
      end
    end

    def self.write_additional_nodes(item_node, question)
    end
  end
end