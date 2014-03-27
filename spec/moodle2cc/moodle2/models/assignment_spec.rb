require 'spec_helper'

describe Moodle2CC::Moodle2::Models::Assignment do

  it_behaves_like 'it has an attribute for', :id
  it_behaves_like 'it has an attribute for', :module_id
  it_behaves_like 'it has an attribute for', :name
  it_behaves_like 'it has an attribute for', :intro
  it_behaves_like 'it has an attribute for', :intro_format
  it_behaves_like 'it has an attribute for', :always_show_description
  it_behaves_like 'it has an attribute for', :submission_drafts
  it_behaves_like 'it has an attribute for', :send_notifications
  it_behaves_like 'it has an attribute for', :send_late_notifications
  it_behaves_like 'it has an attribute for', :due_date
  it_behaves_like 'it has an attribute for', :cut_off_date
  it_behaves_like 'it has an attribute for', :allow_submissions_from_date
  it_behaves_like 'it has an attribute for', :grade
  it_behaves_like 'it has an attribute for', :time_modified
  it_behaves_like 'it has an attribute for', :completion_submit
  it_behaves_like 'it has an attribute for', :require_submission_statement
  it_behaves_like 'it has an attribute for', :team_submission
  it_behaves_like 'it has an attribute for', :require_all_team_members_submit
  it_behaves_like 'it has an attribute for', :team_submission_grouping_id
  it_behaves_like 'it has an attribute for', :blind_marking
  it_behaves_like 'it has an attribute for', :reveal_identities
  it_behaves_like 'it has an attribute for', :online_text_submission
  it_behaves_like 'it has an attribute for', :file_submission
  it_behaves_like 'it has an attribute for', :max_file_size_submission
  it_behaves_like 'it has an attribute for', :max_files_submission
  it_behaves_like 'it has an attribute for', :submission_comments
  it_behaves_like 'it has an attribute for', :feedback_comments
  it_behaves_like 'it has an attribute for', :feedback_files
  it_behaves_like 'it has an attribute for', :offline_grading_worksheet
  it_behaves_like 'it has an attribute for', :visible

end