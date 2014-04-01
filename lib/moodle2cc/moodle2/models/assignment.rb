module Moodle2CC::Moodle2::Models
  class Assignment
    attr_accessor :id, :module_id, :name, :intro, :intro_format, :always_show_description, :submission_drafts,
                  :send_notifications, :send_late_notifications, :due_date, :cut_off_date, :allow_submissions_from_date,
                  :grade, :time_modified, :completion_submit, :require_submission_statement, :team_submission,
                  :require_all_team_members_submit, :team_submission_grouping_id, :blind_marking, :reveal_identities,
                  :online_text_submission, :file_submission, :max_file_size_submission, :max_files_submission,
                  :submission_comments, :feedback_comments, :feedback_files, :offline_grading_worksheet, :visible
  end
end