module Moodle2CC::Moodle2Converter
  class AssignmentConverter
    include ConverterHelper

    def convert(moodle_assignment)
      canvas_assignment = Moodle2CC::CanvasCC::Models::Assignment.new
      canvas_assignment.identifier = generate_unique_identifier_for(moodle_assignment.id, ASSIGNMENT_SUFFIX)
      canvas_assignment.title = moodle_assignment.name
      canvas_assignment.body = moodle_assignment.intro
      canvas_assignment.due_at = Time.at(Integer(moodle_assignment.due_date)) if moodle_assignment.due_date
      canvas_assignment.lock_at = Time.at(Integer(moodle_assignment.cut_off_date)) if moodle_assignment.cut_off_date
      canvas_assignment.unlock_at = Time.at(Integer(moodle_assignment.allow_submissions_from_date)) if moodle_assignment.allow_submissions_from_date
      canvas_assignment.workflow_state = moodle_assignment.visible ? Moodle2CC::CanvasCC::Models::WorkflowState::ACTIVE : Moodle2CC::CanvasCC::Models::WorkflowState::UNPUBLISHED
      canvas_assignment.points_possible = moodle_assignment.grade
      canvas_assignment.grading_type = 'points'
      canvas_assignment.submission_types << 'online_text_entry' if moodle_assignment.online_text_submission == '1'
      canvas_assignment.submission_types += %w(online_url online_upload) if moodle_assignment.file_submission == '1'

      canvas_assignment
    end

  end
end