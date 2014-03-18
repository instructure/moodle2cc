require 'spec_helper'

describe Moodle2CC::Moodle2Converter::AssessmentConverter do
  let(:moodle_quiz) {Moodle2CC::Moodle2::Models::Quizzes::Quiz.new}

  it 'converts a moodle2 quiz to a canvas assessment' do
    moodle_quiz.id = 'quiz id'
    moodle_quiz.name = 'Quiz naem'
    moodle_quiz.intro = '<p> stuff </p>'

    moodle_quiz.time_open = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT').to_i.to_s
    moodle_quiz.time_close = Time.parse('Sat, 08 Feb 2014 18:00:00 GMT').to_i.to_s

    moodle_quiz.attempts_number = '42'
    moodle_quiz.grade_method = 1
    moodle_quiz.password = "password"
    moodle_quiz.subnet = "255.255.255.0"
    moodle_quiz.shuffle_answers = false
    moodle_quiz.time_limit = "100"

    canvas_assessment = subject.convert(moodle_quiz)

    expect(canvas_assessment.identifier).to eq 'm2d1dcd9630366a2c923c30734423c3fe8_assessment'
    expect(canvas_assessment.title).to eq moodle_quiz.name
    expect(canvas_assessment.description).to eq moodle_quiz.intro

    expect(canvas_assessment.unlock_at).to eq Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
    expect(canvas_assessment.lock_at).to eq Time.parse('Sat, 08 Feb 2014 18:00:00 GMT')
    expect(canvas_assessment.allowed_attempts).to eq 42

    expect(canvas_assessment.scoring_policy).to eq 'keep_highest'
    expect(canvas_assessment.access_code).to eq moodle_quiz.password
    expect(canvas_assessment.ip_filter).to eq moodle_quiz.subnet
    expect(canvas_assessment.shuffle_answers).to eq moodle_quiz.shuffle_answers
    expect(canvas_assessment.time_limit).to eq 100
    expect(canvas_assessment.quiz_type).to eq 'practice_quiz'
    expect(canvas_assessment.question_references).to eq moodle_quiz.question_instances

    moodle_quiz.attempts_number = 0 # Infinite attempts
    moodle_quiz.grade_method = 4

    canvas_assessment2 = subject.convert(moodle_quiz)
    expect(canvas_assessment2.allowed_attempts).to eq -1
    expect(canvas_assessment2.scoring_policy).to eq 'keep_latest'
  end

end