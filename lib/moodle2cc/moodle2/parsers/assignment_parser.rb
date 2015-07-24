module Moodle2CC::Moodle2::Parsers
  class AssignmentParser
    include ParserHelper

    ASSIGNMENT_MODULE_NAMES = {
      'assign' => 'assign.xml',
      'assignment' => 'assignment.xml'
    }

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      assignments = []
      ASSIGNMENT_MODULE_NAMES.each do |mod_name, xml_file|
        activity_dirs = activity_directories(@backup_dir, mod_name)
        assignments += activity_dirs.map { |dir| parse_assignment(dir, mod_name, xml_file) }
      end
      assignments
    end

    private

    def parse_assignment(dir, mod_name, xml_file)
      assignment = Moodle2CC::Moodle2::Models::Assignment.new
      activity_dir = File.join(@backup_dir, dir)
      File.open(File.join(activity_dir, xml_file)) do |f|
        xml = Nokogiri::XML(f)
        assignment.id = xml.at_xpath("/activity/#{mod_name}/@id").value
        assignment.module_id = xml.at_xpath('/activity/@moduleid').value
        assignment.name = parse_text(xml, "/activity/#{mod_name}/name")
        assignment.intro = parse_text(xml, "/activity/#{mod_name}/intro")
        assignment.intro_format = parse_text(xml, "/activity/#{mod_name}/introformat")
        assignment.always_show_description = parse_text(xml, "/activity/#{mod_name}/alwaysshowdescription")
        assignment.submission_drafts = parse_text(xml, "/activity/#{mod_name}/submissiondrafts")
        assignment.send_notifications = parse_text(xml, "/activity/#{mod_name}/sendnotifications")
        assignment.send_late_notifications = parse_text(xml, "/activity/#{mod_name}/sendlatenotifications")
        assignment.due_date = parse_text(xml, "/activity/#{mod_name}/duedate")
        assignment.cut_off_date = parse_text(xml, "/activity/#{mod_name}/cutoffdate")
        assignment.allow_submissions_from_date = parse_text(xml, "/activity/#{mod_name}/allowsubmissionsfromdate")
        assignment.grade = parse_text(xml, "/activity/#{mod_name}/grade")
        assignment.time_modified = parse_text(xml, "/activity/#{mod_name}/timemodified")
        assignment.completion_submit = parse_text(xml, "/activity/#{mod_name}/completionsubmit")
        assignment.require_submission_statement = parse_text(xml, "/activity/#{mod_name}/requiresubmissionstatement")
        assignment.team_submission = parse_text(xml, "/activity/#{mod_name}/teamsubmission")
        assignment.require_all_team_members_submit = parse_text(xml, "/activity/#{mod_name}/requireallteammemberssubmit")
        assignment.team_submission_grouping_id = parse_text(xml, "/activity/#{mod_name}/teamsubmissiongroupingid")
        assignment.blind_marking = parse_text(xml, "/activity/#{mod_name}/blindmarking")
        assignment.reveal_identities = parse_text(xml, "/activity/#{mod_name}/revealidentities")
        plugins = xml.at_xpath("/activity/#{mod_name}/plugin_configs")
        if plugins
          assignment.online_text_submission = parse_text(plugins, 'plugin_config[(plugin="onlinetext" and subtype="assignsubmission" and name="enabled")]/value', true)
          assignment.file_submission = parse_text(plugins, 'plugin_config[(plugin="file" and subtype="assignsubmission" and name="enabled")]/value', true)
          assignment.max_files_submission = parse_text(plugins, 'plugin_config[(plugin="file" and subtype="assignsubmission" and name="maxfilesubmissions")]/value', true)
          assignment.max_file_size_submission = parse_text(plugins, 'plugin_config[(plugin="file" and subtype="assignsubmission" and name="maxsubmissionsizebytes")]/value', true)
          assignment.submission_comments = parse_text(plugins, 'plugin_config[(plugin="comments" and subtype="assignsubmission" and name="enabled")]/value', true)
          assignment.feedback_comments = parse_text(plugins, 'plugin_config[(plugin="comments" and subtype="assignfeedback" and name="enabled")]/value', true)
          assignment.feedback_files = parse_text(plugins, 'plugin_config[(plugin="file" and subtype="assignfeedback" and name="enabled")]/value', true)
          assignment.offline_grading_worksheet = parse_text(plugins, 'plugin_config[(plugin="offline" and subtype="assignfeedback" and name="enabled")]/value', true)
        end
      end
      parse_module(activity_dir,assignment)

      assignment
    end

  end
end