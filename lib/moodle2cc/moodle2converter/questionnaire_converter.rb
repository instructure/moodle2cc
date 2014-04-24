module Moodle2CC::Moodle2Converter
  module QuestionnaireConverter
    include ConverterHelper

    def convert_questionnaire(moodle_questionnaire)
      canvas_assessment = Moodle2CC::CanvasCC::Models::Assessment.new
      canvas_assessment.identifier = generate_unique_identifier_for(moodle_questionnaire.id, QUESTIONNAIRE_ASSESSMENT_SUFFIX)
      canvas_assessment.title = moodle_questionnaire.name
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
        8 =>  'multiple_choice_question', # rate 1..5 question
        9 =>  'essay_question', # date question
        10 =>  'numerical_question', # numeric question
        100 =>  'text_only_question', # label question
    }

    def convert_questionnaire_question(moodle_question)
      return unless canvas_type = QUESTION_TYPE_ID_MAP[moodle_question.type_id.to_i]

      canvas_question = Moodle2CC::CanvasCC::Models::Question.create(canvas_type)
      canvas_question.identifier = generate_unique_identifier_for(moodle_question.id, "_questionnaire_question")
      canvas_question.title = moodle_question.name
      canvas_question.material = moodle_question.content
      canvas_question.answers = []
      moodle_question.choices.each do |choice|
        answer = Moodle2CC::CanvasCC::Models::Answer.new
        answer.id = choice[:id]
        answer.answer_text = choice[:content]
        canvas_question.answers << answer
      end
      canvas_question
    end
  end
end