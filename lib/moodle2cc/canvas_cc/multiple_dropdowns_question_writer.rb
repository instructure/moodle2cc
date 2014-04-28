module Moodle2CC::CanvasCC
  class MultipleDropdownsQuestionWriter < QuestionWriter
    register_writer_type 'multiple_dropdowns_question'

    private

    def self.write_responses(presentation_node, question)
      question.responses.each do |response|
        presentation_node.response_lid(:ident => "response_#{response[:id]}") do |response_node|
          response_node.material do |material_node|
            material_node.mattext(response[:id], :texttype => 'text/plain')
          end
          response_node.render_choice do |choice_node|
            response[:choices].each do |choice|
              choice_node.response_label(:ident => choice[:id]) do |label_node|
                label_node.material do |material_node|
                  material_node.mattext(choice[:text], :texttype => 'text/plain')
                end
              end
            end
          end
        end
      end
    end

    def self.write_response_conditions(processing_node, question)
      # this is always an answerless questionnaire question (for now), so no response conditions are necessary
    end
  end
end