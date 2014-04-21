require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::QuizParser do
  subject { Moodle2CC::Moodle2::Parsers::QuizParser.new(fixture_path(File.join('moodle2', 'backup'))) }

  it 'should parse an assignment' do
    quizzes = subject.parse
    expect(quizzes.count).to eq 1
    quiz = quizzes.first

    expect(quiz.id).to eq '1'

    expect(quiz.module_id).to eq '5'
    expect(quiz.name).to eq 'Quiz Name'
    expect(quiz.intro).to eq '<p>Quiz Description</p>'
    expect(quiz.intro_format).to eq '1'
    expect(quiz.time_open).to eq '1393968360'
    expect(quiz.time_close).to eq '1394054760'
    expect(quiz.time_limit).to eq '300'
    expect(quiz.overdue_handling).to eq 'autosubmit'
    expect(quiz.grace_period).to eq '0'
    expect(quiz.preferred_behavior).to eq 'deferredfeedback'
    expect(quiz.attempts_number).to eq '7'
    expect(quiz.attempt_on_last).to eq '0'
    expect(quiz.grade_method).to eq '1'
    expect(quiz.decimal_points).to eq '0'
    expect(quiz.question_decimal_points).to eq '-1'
    expect(quiz.review_attempt).to eq '65552'
    expect(quiz.review_correctness).to eq '0'
    expect(quiz.review_marks).to eq '4112'
    expect(quiz.review_specific_feedback).to eq '0'
    expect(quiz.review_general_feedback).to eq '0'
    expect(quiz.review_right_answer).to eq '0'
    expect(quiz.review_overall_feedback).to eq '16'
    expect(quiz.questions_per_page).to eq '0'
    expect(quiz.nav_method).to eq 'free'

    expect(quiz.shuffle_questions).to eq false
    expect(quiz.shuffle_answers).to eq false

    expect(quiz.sum_grades).to eq '15.00000'
    expect(quiz.grade).to eq '100.00000'
    expect(quiz.time_created).to eq '0'
    expect(quiz.time_modified).to eq '1394656152'
    expect(quiz.password).to eq 'quiz_password'
    expect(quiz.subnet).to eq ''
    expect(quiz.browser_security).to eq '-'
    expect(quiz.delay1).to eq '0'
    expect(quiz.delay2).to eq '0'
    expect(quiz.show_user_picture).to eq '0'
    expect(quiz.show_blocks).to eq '0'
    expect(quiz.visible).to eq true

    expect(quiz.question_instances.map{|q| q[:question]}).to eq (
      ['1', '3', '2', '4', '10', '11', '12', '13', '14', '15', '17']
    )
    expect(quiz.question_instances.map{|q| q[:grade]}).to eq (
      ["1.0000000", "1.0000000", "1.0000000", "5.0000000", "1.0000000",
       "1.0000000", "1.0000000", "1.0000000", "1.0000000", "1.0000000", "1.0000000"]
    )

    expect(quiz.feedbacks.map{|f| f[:text]}).to eq ['<p>100% feedback</p>', '<p>50% feedback</p>']
    expect(quiz.feedbacks.map{|f| f[:format]}).to eq ['1', '1']
    expect(quiz.feedbacks.map{|f| f[:min_grade]}).to eq ['50.00000', '0.00000']
    expect(quiz.feedbacks.map{|f| f[:max_grade]}).to eq ['101.00000', '50.00000']
  end

end