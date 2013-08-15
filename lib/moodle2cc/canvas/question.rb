module Moodle2CC::Canvas
  class Question < Moodle2CC::CC::Question
    META_ATTRIBUTES = [:question_type, :points_possible, :assessment_question_identifierref]
    QUESTION_TYPE_MAP = {
      'calculated' =>  'calculated_question',
      'description' => 'text_only_question',
      'essay' => 'essay_question',
      'match' => 'matching_question',
      'multianswer' => 'embedded_answers_question',
      'multichoice' => 'multiple_choice_question',
      'shortanswer' => 'short_answer_question',
      'numerical' => 'numerical_question',
      'truefalse' => 'true_false_question',
      'choice' => 'multiple_choice_question'
    }
    QUESTION_TYPE_ID_MAP = {
      1 =>  'true_false_question', # yes/no question
      2 =>  'essay_question', # text box question
      3 =>  'essay_question', # essay box question
      4 =>  'multiple_choice_question', # radio buttons question
      5 =>  'multiple_answers_question', # check boxes question
      6 =>  'multiple_choice_question', # dropdown box question
      8 =>  'multiple_dropdowns_question', # rate 1..5 question
      9 =>  'essay_question', # date question
      10 =>  'numerical_question', # numeric question
      100 =>  'text_only_question', # label question
    }

    attr_accessor :material, :general_feedback, :answer_tolerance,
      :formulas, :formula_decimal_places, :vars, :var_sets, :matches, :answers,
      :numericals, :length, *META_ATTRIBUTES

    def initialize(question, assessment=nil)
      super
      @question_type = question.type ? QUESTION_TYPE_MAP[question.type] : QUESTION_TYPE_ID_MAP[question.type_id]
      @points_possible = question.grade
      @general_feedback = question.general_feedback
      @length = question.length

      @answers = []

      unless question.answers.empty?
        @answers = question.answers.map do |answer|
          Moodle2CC::OpenStruct.new(
            :id => answer.id,
            :text => answer.text,
            :fraction => answer.fraction,
            :feedback => answer.feedback
          )
        end
      end

      unless question.choices.nil? || question.choices.empty?
        @answers = question.choices.map do |answer|
          Moodle2CC::OpenStruct.new(
            :id => answer.id,
            :text => answer.content
          )
        end
      end

      calculation = question.calculations.first unless question.calculations.nil?
      if calculation
        @answer_tolerance = calculation.tolerance
        @formula_decimal_places = calculation.correct_answer_format == 1 ? calculation.correct_answer_length : 0
        @formulas = question.answers.map { |a| a.text.gsub(/[\{\}\s]/, '') }
        @vars = calculation.dataset_definitions.map do |ds_def|
          name = ds_def.name
          type, min, max, scale = ds_def.options.split(':')
          {:name => name, :min => min, :max => max, :scale => scale}
        end
        @var_sets = []
        calculation.dataset_definitions.each do |ds_def|
          ds_def.dataset_items.sort_by(&:number).each_with_index do |ds_item, index|
            var_set = @var_sets[index] || {}
            vars = var_set[:vars] || {}
            vars[ds_def.name] = ds_item.value
            var_set[:vars] = vars
            @var_sets[index] = var_set
          end
        end
        @var_sets.map do |var_set|
          answer = 0
          var_set[:vars].each do |k, v|
            answer += v
          end
          var_set[:answer] = answer
        end
      end

      unless question.numericals.nil?
        @numericals = question.numericals.map do |n|
          Moodle2CC::OpenStruct.new(
            :answer => @answers.find { |a| a.id == n.answer_id },
            :tolerance => n.tolerance
          )
        end
      end

      if !question.matches.nil? && question.matches.length > 0
        answers = question.matches.inject({}) do |result, match|
          result[match.code] = match.answer_text
          result
        end
        @matches = question.matches.select do |match|
          match.question_text && match.question_text.strip.length > 0
        end.map do |match|
          Moodle2CC::OpenStruct.new(
            :question => match.question_text,
            :answers => answers,
            :answer => match.code
          )
        end
      end

      material = question.text
      material = question.content || '' if material.nil?
      material = material.gsub(/\{(.*?)\}/, '[\1]')
      material = material + image_html(question.image) unless question.image.nil? || question.image.strip == ''
      material = RDiscount.new(material).to_html if question.format == 4 # markdown
      @material = material

      if @question_type == 'multiple_dropdowns_question' && !@answers.empty? && @length
        choices = @answers[0..(@length-1)]
        if @length >= @answers.length || !choices.all?{|a| !!a.text.match(/^\d/)}
          # the choices don't seem to be present, so construct them
          choices = (1..@length).map do |i|
            Moodle2CC::OpenStruct.new(
              :id => "#{i}",
              :text => "#{i}"
            )
          end
          @responses = @answers
        else
          @responses = @answers[@length..-1]
        end
        @answers = choices
        @responses.each_with_index do |response, index|
          @material << "\n#{response.text} [response#{index + 1}]"
        end
      end

      if question.instance_id
        @assessment_question_identifierref = create_key(question.id, "#{@identifier_prefix}question_")
      end
    end

    def create_item_xml(section_node)
      section_node.item(:title => @title, :ident => @identifier) do |item_node|
        item_node.itemmetadata do |meta_node|
          meta_node.qtimetadata do |qtime_node|
            META_ATTRIBUTES.each do |attr|
              value = send(attr).to_s
              if value && value.length > 0
                qtime_node.qtimetadatafield do |field_node|
                  field_node.fieldlabel attr.to_s
                  field_node.fieldentry value
                end
              end
            end
          end
        end

        item_node.presentation do |presentation_node|
          presentation_node.material do |material_node|
            material_node.mattext(@material, :texttype => 'text/html')
          end
          create_responses(presentation_node)
        end

        item_node.resprocessing do |processing_node|
          processing_node.outcomes do |outcomes_node|
            outcomes_node.decvar(:maxvalue => '100', :minvalue => '0', :varname => 'SCORE', :vartype => 'Decimal')
          end
          if @general_feedback
            processing_node.respcondition(:continue => 'Yes') do |condition_node|
              condition_node.conditionvar do |var_node|
                var_node.other
              end
              condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => 'general_fb')
            end
          end
          create_response_conditions(processing_node)
        end

        create_feedback_nodes(item_node)
        create_additional_nodes(item_node)
      end
    end

    def create_responses(presentation_node)
      case @question_type
      when 'calculated_question'
        presentation_node.response_str(:rcardinality => 'Single', :ident => 'response1') do |response_node|
          response_node.render_fib(:fibtype => 'Decimal') do |render_node|
            render_node.response_label(:ident => 'answer1')
          end
        end
      when 'essay_question', 'short_answer_question', 'embedded_answers_question'
        presentation_node.response_str(:rcardinality => 'Single', :ident => 'response1') do |response_node|
          response_node.render_fib do |render_node|
            render_node.response_label(:ident => 'answer1', :rshuffle => 'No')
          end
        end
      when 'matching_question'
        @matches.each do |match|
          presentation_node.response_lid(:ident => "response_#{match.answer}") do |response_node|
            response_node.material do |material_node|
              material_node.mattext(match.question, :texttype => 'text/html')
            end
            response_node.render_choice do |choice_node|
              match.answers.each do |ident, text|
                choice_node.response_label(:ident => ident) do |label_node|
                  label_node.material do |material_node|
                    material_node.mattext text
                  end
                end
              end
            end
          end
        end
      when 'multiple_choice_question'
        presentation_node.response_lid(:ident => 'response1', :rcardinality => 'Single') do |response_node|
          response_node.render_choice do |choice_node|
            @answers.each do |answer|
              choice_node.response_label(:ident => answer.id) do |label_node|
                label_node.material do |material_node|
                  material_node.mattext answer.text, :texttype => 'text/html'
                end
              end
            end
          end
        end
      when 'multiple_answers_question'
        presentation_node.response_lid(:ident => 'response1', :rcardinality => 'Multiple') do |response_node|
          response_node.render_choice do |choice_node|
            @answers.each do |answer|
              choice_node.response_label(:ident => answer.id) do |label_node|
                label_node.material do |material_node|
                  material_node.mattext answer.text, :texttype => 'text/html'
                end
              end
            end
          end
        end
      when 'multiple_dropdowns_question'
        @responses.each_with_index do |response, index|
          response_id = index + 1
          presentation_node.response_lid(:ident => "response_response#{response_id}") do |response_node|
            response_node.material do |material_node|
              material_node.mattext "response#{response_id}"
            end
            response_node.render_choice do |choice_node|
              @answers.each do |answer|
                choice_node.response_label(:ident => "#{response_id}#{answer.id}") do |label_node|
                  label_node.material do |material_node|
                    material_node.mattext answer.text, :texttype => 'text/html'
                  end
                end
              end
            end
          end
        end
      when 'numerical_question'
        presentation_node.response_str(:rcardinality => 'Single', :ident => 'response1') do |response_node|
          response_node.render_fib(:fibtype => 'Decimal') do |render_fib_node|
            render_fib_node.response_label(:ident => 'answer1')
          end
        end
      when 'true_false_question'
        presentation_node.response_lid(:rcardinality => 'Single', :ident => 'response1') do |response_node|
          response_node.render_choice do |render_choice_node|
            @answers.each do |answer|
              render_choice_node.response_label(:ident => answer.id) do |response_label_node|
                response_label_node.material do |material_node|
                  material_node.mattext(answer.text, :texttype => 'text/html')
                end
              end
            end
          end
        end
      end
    end

    def create_response_conditions(processing_node)
      case @question_type
      when 'calculated_question'
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
      when 'essay_question', 'embedded_answers_question'
        processing_node.respcondition(:continue => 'No') do |condition|
          condition.conditionvar do |var_node|
            var_node.other
          end
        end
      when 'matching_question'
        score = 100.0 / @matches.length.to_f
        @matches.each do |match|
          processing_node.respcondition do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.varequal match.answer, :respident => "response_#{match.answer}"
            end
            condition_node.setvar "%.2f" % score, :varname => 'SCORE', :action => 'Add'
          end
        end
      when 'multiple_choice_question'
        # Feeback
        @answers.each do |answer|
          next unless answer.feedback && answer.feedback.strip.length > 0
          processing_node.respcondition(:continue => 'Yes') do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.varequal answer.id, :respident => 'response1'
            end
            condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => "#{answer.id}_fb")
          end
        end

        # Scores
        @answers.each do |answer|
          processing_node.respcondition(:continue => 'No') do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.varequal answer.id, :respident => 'response1'
            end
            condition_node.setvar(get_score(answer.fraction), :varname => 'SCORE', :action => 'Set')
          end
        end
      when 'multiple_answers_question'
        processing_node.respcondition(:continue => 'No') do |condition_node|
          first = @answers.first
          rest = @answers[1..-1]
          condition_node.conditionvar do |var_node|
            var_node.and do |and_node|
              and_node.varequal first.id, :respident => 'response1'
              rest.each do |answer|
                and_node.not do |not_node|
                  not_node.varequal answer.id, :respident => 'response1'
                end
              end
            end
          end
          condition_node.setvar('100', :varname => 'SCORE', :action => 'Set')
        end
      when 'multiple_dropdowns_question'
        score = 100.0 / @responses.length.to_f
        @responses.each_with_index do |response, index|
          response_id = index + 1
          processing_node.respcondition do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.varequal "#{response_id}#{@answers.first.id}", :respident => "response_response#{response_id}"
            end
            condition_node.setvar "%.2f" % score, :varname => 'SCORE', :action => 'Add'
          end
        end
      when 'numerical_question'
        @numericals.each do |numerical|
          processing_node.respcondition(:continue => 'No') do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.or do |or_node|
                or_node.varequal numerical.answer.text, :respident => 'response1'
                or_node.and do |and_node|
                  and_node.vargte numerical.answer.text.to_f - numerical.tolerance.to_f, :respident => 'response1'
                  and_node.varlte numerical.answer.text.to_f + numerical.tolerance.to_f, :respident => 'response1'
                end
              end
            end
            condition_node.setvar(get_score(numerical.answer.fraction), :varname => "SCORE", :action => 'Set')
            condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => "#{numerical.answer.id}_fb") if numerical.answer.feedback && numerical.answer.feedback.strip.length > 0
          end
        end
      when 'short_answer_question'
        # Feeback
        @answers.each do |answer|
          next unless answer.feedback && answer.feedback.strip.length > 0
          processing_node.respcondition(:continue => 'Yes') do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.varequal answer.text, :respident => 'response1'
            end
            condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => "#{answer.id}_fb")
          end
        end

        # Conditions
        @answers.each do |answer|
          processing_node.respcondition(:continue => 'No') do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.varequal answer.text, :respident => 'response1'
            end
            condition_node.setvar(get_score(answer.fraction), :varname => 'SCORE', :action => "Set")
          end
        end
      when 'true_false_question'
        @answers.each do |answer|
          processing_node.respcondition(:continue => 'No') do |condition_node|
            condition_node.conditionvar do |var_node|
              var_node.varequal answer.id, :respident => 'response1'
            end
            condition_node.displayfeedback(:feedbacktype => 'Response', :linkrefid => "#{answer.id}_fb") if answer.feedback && answer.feedback.strip.length > 0
            condition_node.setvar(get_score(answer.fraction), :varname => 'SCORE', :action => "Set")
          end
        end
      end
    end

    def create_feedback_nodes(item_node)
      # Feeback
      if @general_feedback
        item_node.itemfeedback(:ident => 'general_fb') do |fb_node|
          fb_node.flow_mat do |flow_node|
            flow_node.material do |material_node|
              material_node.mattext(@general_feedback, :texttype => 'text/html')
            end
          end
        end
      end

      case @question_type
      when 'multiple_choice_question', 'numerical_question', 'short_answer_question', 'true_false_question'
        @answers.each do |answer|
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
    end

    def create_additional_nodes(item_node)
      case @question_type
      when 'calculated_question'
        item_node.itemproc_extension do |extension_node|
          extension_node.calculated do |calculated_node|
            calculated_node.answer_tolerance @answer_tolerance
            calculated_node.formulas(:decimal_places => @formula_decimal_places) do |formulas_node|
              @formulas.each do |formula|
                formulas_node.formula formula
              end
            end
            calculated_node.vars do |vars_node|
              @vars.each do |var|
                vars_node.var(:name => var[:name], :scale => var[:scale]) do |var_node|
                  var_node.min var[:min]
                  var_node.max var[:max]
                end
              end
            end
            calculated_node.var_sets do |var_sets_node|
              @var_sets.each do |var_set|
                ident = var_set[:vars].sort.map { |k,v| v.to_s.split('.').join }.flatten.join
                var_sets_node.var_set(:ident => ident) do |var_set_node|
                  var_set[:vars].each do |k, v|
                    var_set_node.var(v, :name => k)
                  end
                  var_set_node.answer var_set[:answer]
                end
              end
            end
          end
        end
      end
    end

    def get_score(fraction)
      return 100 if fraction.nil?
      (100 * fraction).to_i
    end

    def image_html(image)
      image = image.strip
      %{<p><img src="#{WEB_CONTENT_TOKEN}/#{image}" alt="#{image}"/></p>}
    end
  end
end
