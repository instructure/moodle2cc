module Moodle2CC::CanvasCC::Models
  class QuestionBank

    attr_accessor :identifier, :title, :questions, :question_groups, :random_question_references, :original_id, :parent_id

    def initialize
      @questions = []
      @question_groups = []
      @random_question_references = []
    end

    LAR_TYPE = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    ASSESSMENT_NON_CC_FOLDER = 'non_cc_assessments'

    def resources
      [question_bank_resource]
    end

    def question_bank_resource
      resource = Moodle2CC::CanvasCC::Models::Resource.new
      resource.identifier = @identifier
      resource.href = "#{ASSESSMENT_NON_CC_FOLDER}/#{resource.identifier}.xml.qti"
      resource.type = LAR_TYPE
      resource.files = [resource.href]
      resource
    end

    # recursively find all banks that belong to this one
    def find_children_banks(all_banks, visited_banks=[])
      visited_banks << self
      children = []
      sub_children = []
      all_banks.each do |bank|
        children << bank if bank.parent_id && bank.parent_id == self.original_id && !visited_banks.include?(bank)
      end
      children.each do |child|
        sub_children += child.find_children_banks(all_banks, visited_banks)
      end
      return children + sub_children
    end
  end
end