module Moodle2CC::CanvasCC
  class EssayQuestionWriter < QuestionWriter
    register_writer_type 'essay_question'

    private

    def self.write_responses(presentation_node, question)
      ShortAnswerQuestionWriter.write_responses(presentation_node, question)
    end

    def self.write_response_conditions(processing_node, question)
      processing_node.respcondition(:continue => 'No') do |condition|
        condition.conditionvar do |var_node|
          var_node.other
        end
      end
    end
  end
end