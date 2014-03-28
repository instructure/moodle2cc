module Moodle2CC::CanvasCC::Models
  class Assessment
    META_ATTRIBUTES = [:title, :description, :allowed_attempts,
                       :scoring_policy, :access_code, :ip_filter, :shuffle_answers, :time_limit, :quiz_type]
    DATETIME_ATTRIBUTES = [:lock_at, :unlock_at]

    LAR_TYPE = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
    ASSESSMENT_NON_CC_FOLDER = 'non_cc_assessments'

    attr_accessor :identifier, :workflow_state, :question_references, :questions, *META_ATTRIBUTES, *DATETIME_ATTRIBUTES

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
      @questions ||= []
      @question_references.each do |ref|
        question = nil
        question_banks.each do |bank|
          break if question = bank.questions.detect{|q| q.identifier.to_s == ref[:question]}
        end

        if question
          question.assessment_question_identifierref ||= "question_#{question.identifier}"
          copy = question.dup
          copy.points_possible = ref[:grade] if ref[:grade]
          @questions << copy
        end
      end
    end
  end
end