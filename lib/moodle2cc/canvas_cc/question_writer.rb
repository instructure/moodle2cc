module Moodle2CC::CanvasCC
  class QuestionWriter

    @@subclasses = {}

    def self.write_question(node, question)
      if c = @@subclasses[question.question_type]
        c.write_question_item_xml(node, question)
      else
        raise "Unknown question writer type: #{question.question_type}"
      end
    end

    def self.register_writer_type(name)
      @@subclasses[name] = self
    end

    def self.write_question_item_xml(node, question)
      node.item(:title => question.title, :ident => question.identifier) do |item_node|
        write_qti_metadata(item_node, question)
        write_presentation(item_node, question)
        write_resprocessing(item_node, question)
        write_general_feedback(item_node, question)
        write_additional_nodes(item_node, question)
      end
    end

    private

    def self.write_qti_metadata(item_node, question)
      item_node.itemmetadata do |meta_node|
        meta_node.qtimetadata do |qtime_node|
          Moodle2CC::CanvasCC::Models::Question::QTI_META_ATTRIBUTES.each do |attr|
            value = question.send(attr).to_s
            if value && value.length > 0
              qtime_node.qtimetadatafield do |field_node|
                field_node.fieldlabel attr.to_s
                field_node.fieldentry value
              end
            end
          end
        end
      end
    end

    def self.write_presentation(item_node, question)
      item_node.presentation do |presentation_node|
        presentation_node.material do |material_node|
          material_node.mattext(question.material, :texttype => 'text/html')
        end

        write_responses(presentation_node, question)
      end
    end

    def self.write_responses(presentation_node, question)
      raise "needs to be implemented in question writer subclass"
    end

    def self.write_resprocessing(item_node, question)
      item_node.resprocessing do |processing_node|
        processing_node.outcomes do |outcomes_node|
          outcomes_node.decvar(:maxvalue => '100', :minvalue => '0', :varname => 'SCORE', :vartype => 'Decimal')
        end
        if question.general_feedback
          processing_node.respcondition(:continue => 'Yes') do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.other
            end
            condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => 'general_fb')
          end
        end
        write_response_conditions(processing_node, question)
      end
    end

    def self.write_response_conditions(processing_node, question)
      raise "needs to be implemented in question writer subclass"
    end

    def self.write_general_feedback(item_node, question)
      if question.general_feedback
        item_node.itemfeedback(:ident => 'general_fb') do |fb_node|
          fb_node.flow_mat do |flow_node|
            flow_node.material do |material_node|
              material_node.mattext(question.general_feedback, :texttype => 'text/html')
            end
          end
        end
      end
    end

    def self.write_additional_nodes(item_node, question)
      # implement in sub-classes if needed
    end

    # used for 'multiple_choice_question', 'numerical_question', 'short_answer_question', 'true_false_question'
    def self.write_standard_answer_feedbacks(item_node, question)
      question.answers.each do |answer|
        next unless answer.feedback && answer.feedback.strip.length > 0
        item_node.itemfeedback(:ident => "#{answer.id}_fb") do |feedback_node|
          feedback_node.flow_mat do |flow_node|
            flow_node.material do |material_node|
              material_node.mattext answer.feedback, :texttype => 'text/html'
            end
          end
        end
      end
    end

    # helper
    def self.convert_fraction_to_score(fraction)
      return 100 if fraction.nil?
      (100 * fraction).to_i
    end
  end
end

require_relative 'true_false_question_writer'
