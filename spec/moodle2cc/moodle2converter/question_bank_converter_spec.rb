require 'spec_helper'

describe Moodle2CC::Moodle2Converter::QuestionBankConverter do
  let(:moodle_category) {Moodle2CC::Moodle2::Models::Quizzes::QuestionCategory.new}

  it 'converts a moodle2 question category to a canvas question bank' do
    moodle_category.id = 'category id'
    moodle_category.name = 'category name'

    canvas_bank = subject.convert(moodle_category)

    expect(canvas_bank.identifier).to eq 'm223458e5bf21c734dcbf0b582c2efd2a0_question_bank'
    expect(canvas_bank.title).to eq moodle_category.name
  end

  it 'converts moodle2 questions using the correct question converters' do
    moodle_category.questions << Moodle2CC::Moodle2::Models::Quizzes::Question.create('truefalse')

    canvas_bank = subject.convert(moodle_category)

    expect(canvas_bank.questions.length).to eq 1
    expect(canvas_bank.questions.first.type).to eq 'true_false_question'
  end
end