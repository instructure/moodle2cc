module Moodle2CC::Moodle2Converter
  module FeedbackConverter
    include ConverterHelper

    def convert_feedback(moodle_feedback)
      canvas_assessment = Moodle2CC::CanvasCC::Models::Assessment.new
      canvas_assessment.identifier = generate_unique_identifier_for(moodle_feedback.id, FEEDBACK_ASSESSMENT_SUFFIX)
      canvas_assessment.title = truncate_text(moodle_feedback.name)
      canvas_assessment.description = moodle_feedback.intro
      canvas_assessment.workflow_state = workflow_state(moodle_feedback.visible)

      canvas_assessment.lock_at = Time.at(Integer(moodle_feedback.time_close)) if moodle_feedback.time_close
      canvas_assessment.unlock_at = Time.at(Integer(moodle_feedback.time_open)) if moodle_feedback.time_open

      canvas_assessment.scoring_policy = 'keep_latest'
      canvas_assessment.quiz_type = 'survey'

      canvas_assessment.items = []
      moodle_feedback.items.each do |item|
        if canvas_question = convert_feedback_question(item)
          canvas_assessment.items << canvas_question
        end
      end

      canvas_assessment
    end

    QUESTION_TYPE_MAP = {
      'label' => 'text_only_question',
      'textarea' => 'essay_question',
      'multichoice' => 'multiple_choice_question',
      'multichoicerated' => 'multiple_choice_question',
      'numeric' => 'numerical_question',
      'textfield' => 'short_answer_question'
    }

    def convert_feedback_question(moodle_question)
      return unless canvas_type = QUESTION_TYPE_MAP[moodle_question.type]

      canvas_question = Moodle2CC::CanvasCC::Models::Question.create(canvas_type)
      canvas_question.identifier = generate_unique_identifier_for(moodle_question.id, "_feedback_question")
      if moodle_question.type == 'label'
        canvas_question.title = truncate_text(moodle_question.name)
        canvas_question.material = moodle_question.presentation
      else
        canvas_question.title = truncate_text(moodle_question.label)
        canvas_question.material = moodle_question.name
      end

      if ['multichoice', 'multichoicerated'].include?(moodle_question.type)
        choices = moodle_question.presentation.to_s.sub('r>>>>>', '').split("\\n").map do |c|
          c = c.strip
          c = c.sub('|', '') if c.start_with?('|')
          if moodle_question.type == 'multichoicerated' && c =~ /(\d+)\#\#\#\#(.*)/
            c = "[#{$1}] #{$2}"
          end
          c
        end

        choices.each_with_index do |choice, num|
          answer = Moodle2CC::CanvasCC::Models::Answer.new
          answer.id = generate_unique_identifier_for(moodle_question.id, "_answer#{num + 1}")
          answer.answer_text = choice
          canvas_question.answers << answer
        end
      end
      canvas_question
    end
  end
end