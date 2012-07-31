module Moodle2CC::CC
  class Question
    include CCHelper

    attr_accessor :id, :title, :identifier

    def initialize(question, assessment=nil)
      @id = question.id
      @title = CGI.unescapeHTML((question.name || '').gsub('$@NULL@$', ''))
      @identifier_prefix = "#{assessment.mod.mod_type}_" if assessment

      if question.instance_id
        @identifier = create_key(question.instance_id, "#{@identifier_prefix}question_instance_")
      else
        @identifier = create_key(question.id, "#{@identifier_prefix}question_")
      end
    end

    def create_item_xml(section_node)
    end

  end
end
