module Moodle2CC::Moodle2Converter
  class AssessmentConverter

    def convert(moodle_quiz)
      canvas_assessment = Moodle2CC::CanvasCC::Model::Assessment.new
      canvas_assessment.identifier = moodle_quiz.id
      canvas_assessment.title = moodle_quiz.name
      canvas_assessment.description = moodle_quiz.intro

      canvas_assessment.lock_at = Time.at(Integer(moodle_quiz.time_close)) if moodle_quiz.time_close
      canvas_assessment.unlock_at = Time.at(Integer(moodle_quiz.time_open)) if moodle_quiz.time_open

      canvas_assessment.allowed_attempts = Integer(moodle_quiz.attempts_number)
      canvas_assessment.allowed_attempts = -1 if canvas_assessment.allowed_attempts == 0

      canvas_assessment.scoring_policy = moodle_quiz.grade_method == 4 ? 'keep_latest' : 'keep_highest'
      canvas_assessment.access_code = moodle_quiz.password
      canvas_assessment.ip_filter = moodle_quiz.subnet
      canvas_assessment.shuffle_answers = moodle_quiz.shuffle_answers
      canvas_assessment.time_limit = Integer(moodle_quiz.time_limit) if moodle_quiz.time_limit
      canvas_assessment.quiz_type = 'practice_quiz'

      canvas_assessment.question_references = moodle_quiz.question_instances

      canvas_assessment
    end

  end
end