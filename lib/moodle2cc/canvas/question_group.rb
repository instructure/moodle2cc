module Moodle2CC::Canvas
  class QuestionGroup
    include Moodle2CC::CC::CCHelper
    attr_accessor :id, :title, :selection_number, :points_per_item,
      :question_bank, :sourcebank_ref, :identifier

    def initialize(params={})
      @id = params[:id] || 1
      @title = "Group #{@id}"
      @selection_number = 1
      @points_per_item = params[:points_per_item] || 1
      @question_bank = params[:question_bank]
      @sourcebank_ref = @question_bank.identifier if @question_bank
      @identifier = create_key @id, 'question_group_'
    end

    def increment_selection_number
      @selection_number += 1
    end

    def create_item_xml(root_node)
      root_node.section(:title => @title, :ident => @identifier) do |section_node|
        section_node.selection_ordering do |ordering_node|
          ordering_node.selection do |selection_node|
            selection_node.sourcebank_ref @sourcebank_ref
            selection_node.selection_number @selection_number
            selection_node.selection_extension do |extension_node|
              extension_node.points_per_item @points_per_item
            end
          end
        end
      end
    end
  end
end
