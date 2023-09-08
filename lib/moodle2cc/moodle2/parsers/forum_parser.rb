module Moodle2CC::Moodle2::Parsers
  class ForumParser
    include ParserHelper

    FORUM_MODULE_NAME = 'forum'
    HSU_MODULE_NAME = 'hsuforum'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_directories(@backup_dir, FORUM_MODULE_NAME).map { |dir| parse_forum(dir, FORUM_MODULE_NAME) } +
        activity_directories(@backup_dir, HSU_MODULE_NAME).map { |dir| parse_forum(dir, HSU_MODULE_NAME) }
    end

    private

    def parse_forum(forum_dir, module_name)
      xml_file = "#{module_name}.xml"
      forum = Moodle2CC::Moodle2::Models::Forum.new
      activity_dir = File.join(@backup_dir, forum_dir)
      File.open(File.join(activity_dir, xml_file)) do |f|
        forum_xml = Nokogiri::XML(f)
        forum.id = forum_xml.at_xpath("/activity/#{module_name}/@id").value
        forum.module_id = forum_xml.at_xpath("/activity/@moduleid").value
        forum.name = parse_text(forum_xml, "/activity/#{module_name}/name")
        forum.type = parse_text(forum_xml, "/activity/#{module_name}/type")
        forum.intro = parse_text(forum_xml, "/activity/#{module_name}/intro")
        forum.intro_format = parse_text(forum_xml, "/activity/#{module_name}/introformat")
        forum.assessed = parse_text(forum_xml, "/activity/#{module_name}/assessed")
        forum.assess_time_start = parse_text(forum_xml, "/activity/#{module_name}/assesstimestart")
        forum.assess_time_finish = parse_text(forum_xml, "/activity/#{module_name}/assesstimefinish")
        forum.scale = parse_text(forum_xml, "/activity/#{module_name}/scale")
        forum.max_bytes = parse_text(forum_xml, "/activity/#{module_name}/maxbytes")
        forum.max_attachments = parse_text(forum_xml, "/activity/#{module_name}/maxattachments")
        forum.force_subscribe = parse_boolean(forum_xml, "/activity/#{module_name}/forcesubscribe")
        forum.tracking_type = parse_text(forum_xml, "/activity/#{module_name}/trackingtype")
        forum.rss_type = parse_text(forum_xml, "/activity/#{module_name}/rsstype")
        forum.rss_articles = parse_text(forum_xml, "/activity/#{module_name}/rssarticles")
        forum.time_modified = parse_text(forum_xml, "/activity/#{module_name}/timemodified")
        forum.warn_after = parse_text(forum_xml, "/activity/#{module_name}/warnafter")
        forum.block_after = parse_text(forum_xml, "/activity/#{module_name}/blockafter")
        forum.block_period = parse_text(forum_xml, "/activity/#{module_name}/blockperiod")
        forum.completion_discussions = parse_text(forum_xml, "/activity/#{module_name}/completiondiscussions")
        forum.completion_replies = parse_text(forum_xml, "/activity/#{module_name}/completionreplies")
        forum.completion_posts = parse_text(forum_xml, "/activity/#{module_name}/completionposts")
      end
      grade_file = File.join(activity_dir, "grades.xml")
      if File.exist?(grade_file)
        File.open(grade_file) do |f|
          grade_xml = Nokogiri::XML(f)
          if node = grade_xml.at_xpath("activity_gradebook/grade_items/grade_item/grademax")
            forum.points_possible = node.text
          end
        end
      end
      parse_module(activity_dir, forum)
      forum
    end

  end
end