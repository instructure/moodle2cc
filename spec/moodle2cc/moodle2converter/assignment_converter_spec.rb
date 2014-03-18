require 'spec_helper'

describe Moodle2CC::Moodle2Converter::AssignmentConverter do
  let(:moodle_assign) {Moodle2CC::Moodle2::Models::Assignment.new}

  it 'converts a moodle2 assignment to a canvas assignment' do
    moodle_assign.id = 'm20d0a81167d2888626a540e58a658f5b4_assignment'
    moodle_assign.name = 'Assignment Name'
    moodle_assign.intro = '<p> Some Assignment Body</p>'
    moodle_assign.due_date = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT').to_i
    moodle_assign.cut_off_date = Time.parse('Sat, 08 Feb 2014 18:00:00 GMT').to_i
    moodle_assign.allow_submissions_from_date = Time.parse('Sat, 08 Feb 2014 01:00:00 GMT').to_i
    moodle_assign.grade = '30'
    moodle_assign.online_text_submission = '1'
    moodle_assign.file_submission = '1'

    canvas_assign = subject.convert(moodle_assign)

    expect(canvas_assign.identifier).to eq 'm2d12c3b616363d9f3088155447732972b_assignment'
    expect(canvas_assign.title).to eq 'Assignment Name'
    expect(canvas_assign.body).to eq '<p> Some Assignment Body</p>'
    expect(canvas_assign.due_at).to eq Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
    expect(canvas_assign.lock_at).to eq Time.parse('Sat, 08 Feb 2014 18:00:00 GMT')
    expect(canvas_assign.unlock_at).to eq Time.parse('Sat, 08 Feb 2014 01:00:00 GMT')
    expect(canvas_assign.workflow_state).to eq 'active'
    expect(canvas_assign.points_possible).to eq '30'
    expect(canvas_assign.grading_type).to eq 'points'



  end

end