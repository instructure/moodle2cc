module Moodle2CC::Moodle2Converter
  module QuestionnaireConverter
    include ConverterHelper

    def convert_questionnaire(moodle_questionnaire)
      canvas_assessment = Moodle2CC::CanvasCC::Models::Assessment.new
      canvas_assessment.identifier = generate_unique_identifier_for(moodle_questionnaire.id, QUESTIONNAIRE_ASSESSMENT_SUFFIX)
      canvas_assessment.title = truncate_text(moodle_questionnaire.name)
      canvas_assessment.description = moodle_questionnaire.intro
      canvas_assessment.workflow_state = workflow_state(moodle_questionnaire.visible)

      canvas_assessment.lock_at = Time.at(Integer(moodle_questionnaire.close_date)) if moodle_questionnaire.close_date
      canvas_assessment.unlock_at = Time.at(Integer(moodle_questionnaire.open_date)) if moodle_questionnaire.open_date

      canvas_assessment.scoring_policy = 'keep_latest'
      canvas_assessment.quiz_type = 'survey'

      canvas_assessment.items = []
      moodle_questionnaire.questions.each do |question|
        next if question.deleted
        if canvas_question = convert_questionnaire_question(question)
          canvas_assessment.items << canvas_question
        end
      end

      canvas_assessment
    end

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

    def convert_questionnaire_question(moodle_question)
      return unless canvas_type = QUESTION_TYPE_ID_MAP[moodle_question.type_id.to_i]

      canvas_question = Moodle2CC::CanvasCC::Models::Question.create(canvas_type)
      canvas_question.identifier = generate_unique_identifier_for(moodle_question.id, "_questionnaire_question")
      canvas_question.title = truncate_text(moodle_question.name)
      canvas_question.material = moodle_question.content
      canvas_question.answers = []

      if canvas_type == 'multiple_dropdowns_question'
        # rating scale question
        convert_rating_question(moodle_question, canvas_question)
      else
        moodle_question.choices.each do |choice|
          answer = Moodle2CC::CanvasCC::Models::Answer.new
          answer.id = choice[:id]
          answer.answer_text = choice[:content]
          canvas_question.answers << answer
        end
      end

      canvas_question
    end

    # For l..x rating questions
    def convert_rating_question(moodle_question, canvas_question)
      choices = create_rating_choices(moodle_question)
      canvas_question.responses = []

      moodle_question.choices.each_with_index do |answer, answer_idx|
        response = {:id => "response#{answer_idx + 1}", :choices => []}

        # add dropdown to the question text
        canvas_question.material = canvas_question.material.to_s + "<p>#{answer[:content]} [#{response[:id]}]</p>"

        choices.each_with_index do |choice, choice_idx|
          response[:choices] << {:id => "#{moodle_question.id}_choice_#{answer_idx}_#{choice_idx}", :text => choice}
        end

        canvas_question.responses << response
      end
    end

    def create_rating_choices(moodle_question)
      scale = (moodle_question.length || 5).to_i
      choices = (1..scale).map(&:to_s)
      if moodle_question.precise.to_i == 1
        choices << "N/A"
      end
      choices
    end
  end
end