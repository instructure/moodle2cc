require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::AssignmentParser do
  subject { Moodle2CC::Moodle2::Parsers::AssignmentParser.new(fixture_path(File.join('moodle2', 'backup'))) }

  it 'should parse an assignment' do
    assignments = subject.parse
    expect(assignments.count).to eq 1
    assign = assignments.first
    expect(assign.id).to eq '1'
    expect(assign.module_id).to eq '4'
    expect(assign.name).to eq 'Assignment Name'
    expect(assign.intro).to eq "<p>Assignemnt\u00A0Description</p>"
    expect(assign.intro_format).to eq '1'
    expect(assign.always_show_description).to eq '1'
    expect(assign.submission_drafts).to eq '1'
    expect(assign.send_notifications).to eq '1'
    expect(assign.send_late_notifications).to eq '1'
    expect(assign.due_date).to eq '1394221500'
    expect(assign.cut_off_date).to eq '1394221500'
    expect(assign.allow_submissions_from_date).to eq '1393616700'
    expect(assign.grade).to eq '100'
    expect(assign.time_modified).to eq '1393924398'
    expect(assign.completion_submit).to eq '0'
    expect(assign.require_submission_statement).to eq '0'
    expect(assign.team_submission).to eq '1'
    expect(assign.require_all_team_members_submit).to eq '1'
    expect(assign.team_submission_grouping_id).to eq '0'
    expect(assign.blind_marking).to eq '1'
    expect(assign.reveal_identities).to eq '0'
    expect(assign.online_text_submission).to eq '1'
    expect(assign.file_submission).to eq '1'
    expect(assign.max_file_size_submission).to eq '0'
    expect(assign.max_files_submission).to eq '2'
    expect(assign.submission_comments).to eq '0'
    expect(assign.feedback_comments).to eq '1'
    expect(assign.feedback_files).to eq '1'
    expect(assign.offline_grading_worksheet).to eq '1'

  end

end