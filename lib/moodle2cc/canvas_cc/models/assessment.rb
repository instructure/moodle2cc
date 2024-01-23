# frozen_string_literal: true

module Moodle2CC::CanvasCC::Models
  class Assessment
    META_ATTRIBUTES = %i[title
                         description
                         allowed_attempts
                         scoring_policy
                         access_code
                         ip_filter
                         shuffle_answers
                         time_limit
                         quiz_type].freeze
    DATETIME_ATTRIBUTES = [:lock_at, :unlock_at].freeze

    ASSESSMENT_TYPE = "imsqti_xmlv1p2/imscc_xmlv1p1/assessment"
    LAR_TYPE = "associatedcontent/imscc_xmlv1p1/learning-application-resource"
    ASSESSMENT_NON_CC_FOLDER = "non_cc_assessments"

    attr_accessor :identifier, :workflow_state, :question_references, :items, *META_ATTRIBUTES, *DATETIME_ATTRIBUTES

    def initialize
      @question_references = []
    end

    def resources
      [cc_assessment_resource, canvas_assessment_resource]
    end

    def cc_assessment_resource
      resource = Moodle2CC::CanvasCC::Models::Resource.new
      resource.identifier = @identifier
      resource.type = ASSESSMENT_TYPE
      resource.dependencies = ["#{@identifier}_meta"]
      resource.files = [] # TODO: export cc qti file
      resource
    end

    def canvas_assessment_resource
      resource = Moodle2CC::CanvasCC::Models::Resource.new
      resource.identifier = "#{@identifier}_meta"
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

    def resolve_question_references!(question_banks)
      @items ||= []

      # keep track of each time a bank is referenced through a random question reference
      random_bank_counts = {}

      @question_references.each do |ref|
        question = nil
        group = nil
        question_banks.each do |bank|
          break if (question = bank.questions.detect { |q| q.original_identifier.to_s == ref[:question] })
          break if (question = bank.questions.detect { |q| q.bank_entry_id.to_s == ref[:bank_entry_id] })
          break if (group = bank.question_groups.detect { |g| g.identifier.to_s == ref[:question] })

          next unless bank.random_question_references.any? { |r| r.to_s == ref[:question] }

          random_bank_counts[bank] ||= 0
          random_bank_counts[bank] += 1
          break
        end

        if question
          question.assessment_question_identifierref ||= "question_#{question.identifier}"
          copy = question.dup
          copy.identifier = "#{copy.identifier}_copy"
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

      random_bank_counts.each do |bank, count|
        new_group = Moodle2CC::CanvasCC::Models::QuestionGroup.new
        new_group.identifier = "#{@identifier}#{bank.identifier}_random_group"
        new_group.selection_number = count

        new_group.questions = bank.questions.map(&:dup)
        child_banks = bank.find_children_banks(question_banks)
        child_banks.each do |child|
          new_group.questions += child.questions.map(&:dup)
        end

        @items << new_group
      end

      @items.select { |i| i.is_a?(Moodle2CC::CanvasCC::Models::QuestionGroup) }.each do |group|
        group.questions.each do |q|
          @items.delete_if { |i| i.respond_to?(:original_identifier) && i.original_identifier == q.original_identifier }
        end
      end
    end
  end
end
