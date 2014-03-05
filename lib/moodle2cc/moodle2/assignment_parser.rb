module Moodle2CC::Moodle2
  class AssignmentParser

    ASSIGNMENT_XML = 'assign.xml'
    NULL_XML_VALUE = '$@NULL@$'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = parse_moodle_backup
      activity_dirs.map { |dir| parse_assignemnt(dir) }
    end

    private

    def parse_moodle_backup
      File.open(File.join(@backup_dir, Moodle2CC::Moodle2::Extractor::MOODLE_BACKUP_XML)) do |f|
        moodle_backup_xml = Nokogiri::XML(f)
        activities = moodle_backup_xml./('/moodle_backup/information/contents/activities').xpath('activity[modulename = "assign"]')
        activities.map { |forum| forum./('directory').text }
      end
    end

    def parse_assignemnt(dir)
      assignment = Moodle2CC::Moodle2::Model::Assignment.new
      File.open(File.join(@backup_dir, dir, ASSIGNMENT_XML)) do |f|
        xml = Nokogiri::XML(f)
        assignment.id = xml.at_xpath('/activity/assign/@id').value
        assignment.module_id = xml.at_xpath('/activity/@moduleid').value
        assignment.name = parse_text(xml, '/activity/assign/name')
        assignment.intro = parse_text(xml, '/activity/assign/intro')
        assignment.intro_format = parse_text(xml, '/activity/assign/introformat')
        assignment.always_show_description = parse_text(xml, '/activity/assign/alwaysshowdescription')
        assignment.submission_drafts = parse_text(xml, '/activity/assign/submissiondrafts')
        assignment.send_notifications = parse_text(xml, '/activity/assign/sendnotifications')
        assignment.send_late_notifications = parse_text(xml, '/activity/assign/sendlatenotifications')
        assignment.due_date = parse_text(xml, '/activity/assign/duedate')
        assignment.cut_off_date = parse_text(xml, '/activity/assign/cutoffdate')
        assignment.allow_submissions_from_date = parse_text(xml, '/activity/assign/allowsubmissionsfromdate')
        assignment.grade = parse_text(xml, '/activity/assign/grade')
        assignment.time_modified = parse_text(xml, '/activity/assign/timemodified')
        assignment.completion_submit = parse_text(xml, '/activity/assign/completionsubmit')
        assignment.require_submission_statement = parse_text(xml, '/activity/assign/requiresubmissionstatement')
        assignment.team_submission = parse_text(xml, '/activity/assign/teamsubmission')
        assignment.require_all_team_members_submit = parse_text(xml, '/activity/assign/requireallteammemberssubmit')
        assignment.team_submission_grouping_id = parse_text(xml, '/activity/assign/teamsubmissiongroupingid')
        assignment.blind_marking = parse_text(xml, '/activity/assign/blindmarking')
        assignment.reveal_identities = parse_text(xml, '/activity/assign/revealidentities')
        plugins = xml.at_xpath('/activity/assign/plugin_configs')
        assignment.online_text_submission = plugins.at_xpath('plugin_config[(plugin="onlinetext" and subtype="assignsubmission" and name="enabled")]/value').text
        assignment.file_submission = plugins.at_xpath('plugin_config[(plugin="file" and subtype="assignsubmission" and name="enabled")]/value').text
        assignment.max_files_submission = plugins.at_xpath('plugin_config[(plugin="file" and subtype="assignsubmission" and name="maxfilesubmissions")]/value').text
        assignment.max_file_size_submission = plugins.at_xpath('plugin_config[(plugin="file" and subtype="assignsubmission" and name="maxsubmissionsizebytes")]/value').text
        assignment.submission_comments = plugins.at_xpath('plugin_config[(plugin="comments" and subtype="assignsubmission" and name="enabled")]/value').text
        assignment.feedback_comments = plugins.at_xpath('plugin_config[(plugin="comments" and subtype="assignfeedback" and name="enabled")]/value').text
        assignment.feedback_files = plugins.at_xpath('plugin_config[(plugin="file" and subtype="assignfeedback" and name="enabled")]/value').text
        assignment.offline_grading_worksheet = plugins.at_xpath('plugin_config[(plugin="offline" and subtype="assignfeedback" and name="enabled")]/value').text
      end
      assignment
    end

    def parse_text(node, xpath)
      if v_node = node.%(xpath)
        value = v_node.text
        value unless value == NULL_XML_VALUE
      end
    end

  end
end