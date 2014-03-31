module Moodle2CC::CanvasCC
  class QuestionGroupWriter

    def self.write_question_group(node, question_group)
      node.section(:title => question_group.title, :ident => question_group.identifier) do |section_node|
        section_node.selection_ordering do |so_node|
          so_node.selection do |s_node|
            s_node.selection_number question_group.selection_number
            if question_group.points_per_item
              s_node.selection_extension do |se_node|
                se_node.points_per_item question_group.points_per_item
              end
            end
          end
        end

        question_group.questions.each do |question|
          Moodle2CC::CanvasCC::QuestionWriter.write_question(section_node, question)
        end
      end
    end
  end
end
