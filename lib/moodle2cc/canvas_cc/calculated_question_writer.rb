module Moodle2CC::CanvasCC
  class CalculatedQuestionWriter < QuestionWriter
    register_writer_type 'calculated_question'

    private

    def self.write_responses(presentation_node, question)
      presentation_node.response_str(:rcardinality => 'Single', :ident => 'response1') do |response_node|
        response_node.render_fib(:fibtype => 'Decimal') do |render_node|
          render_node.response_label(:ident => 'answer1')
        end
      end
    end

    def self.write_response_conditions(processing_node, question)
      processing_node.respcondition(:title => 'correct') do |condition|
        condition.conditionvar do |var_node|
          var_node.other
        end
        condition.setvar('100', :varname => 'SCORE', :action => 'Set')
      end
      processing_node.respcondition(:title => 'incorrect') do |condition|
        condition.conditionvar do |var_node|
          var_node.other
        end
        condition.setvar('0', :varname => 'SCORE', :action => 'Set')
      end
    end

    def self.write_additional_nodes(item_node, question)
      item_node.itemproc_extension do |extension_node|
        extension_node.calculated do |calculated_node|
          calculated_node.answer_tolerance question.tolerance

          formula_decimal_places = question.correct_answer_format.to_i == 1 ? question.correct_answer_length : 0
          calculated_node.formulas(:decimal_places => formula_decimal_places) do |formulas_node|
            formulas = question.answers.map { |a| a.answer_text.gsub(/[\{\}\s]/, '') }
            formulas.each do |formula|
              formulas_node.formula formula
            end
          end
          calculated_node.vars do |vars_node|
            vars = question.dataset_definitions.map do |ds_def|
              name = ds_def[:name]
              type, min, max, scale = ds_def[:options].split(':')
              {:name => name, :min => min, :max => max, :scale => scale}
            end

            vars.each do |var|
              vars_node.var(:name => var[:name], :scale => var[:scale]) do |var_node|
                var_node.min var[:min]
                var_node.max var[:max]
              end
            end
          end
        end
      end

    end
  end
end