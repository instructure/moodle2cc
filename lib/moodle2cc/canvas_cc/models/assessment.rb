module Moodle2CC::CanvasCC::Models
  class Assessment
    META_ATTRIBUTES = [:title, :description, :allowed_attempts,
                       :scoring_policy, :access_code, :ip_filter, :shuffle_answers, :time_limit, :quiz_type]
    DATETIME_ATTRIBUTES = [:lock_at, :unlock_at]

    LAR_TYPE = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    ASSESSMENT_NON_CC_FOLDER = 'non_cc_assessments'

    attr_accessor :identifier, :workflow_state, :question_references, :items, *META_ATTRIBUTES, *DATETIME_ATTRIBUTES

    def initialize
      @question_references = []
    end

    def resources
      [assessment_resource]
    end

    def assessment_resource
      resource = Moodle2CC::CanvasCC::Models::Resource.new
      resource.identifier = @identifier
      resource.href = meta_file_path
      resource.type = LAR_TYPE
      resource.files = [meta_file_path, qti_file_path]
      resource
    end

    def meta_file_path
      "#{@identifier}/assessment_meta.xml"
    end

    def qti_file_path
      "#{ASSESSMENT_NON_CC_FOLDER}/#{@identifier}.xml.qti"
    end

    def resolve_question_references(question_banks)
      @items ||= []
      @question_references.each do |ref|
        question = nil
        group = nil
        question_banks.each do |bank|
          break if (question = bank.questions.detect{|q| q.identifier.to_s == ref[:question]}) ||
            (group = bank.question_groups.detect{|g| g.identifier.to_s == ref[:question]})
        end

        if question
          question.assessment_question_identifierref ||= "question_#{question.identifier}"
          copy = question.dup
          copy.points_possible = ref[:grade] if ref[:grade]
          @items << copy
        elsif group
          copy = group.dup
          if ref[:grade] && copy.selection_number.to_i != 0
            copy.points_per_item = ref[:grade].to_f / copy.selection_number.to_i
          end
          @items << copy
        end
      end

      @items.select{|i| i.is_a?(Moodle2CC::CanvasCC::Models::QuestionGroup)}.each do |group|
        group.questions.each do |q|
          @items.delete_if{|i| i.identifier.to_s == q.identifier}
        end
      end
    end
  end
end