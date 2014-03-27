module Moodle2CC::Moodle2::Parsers
  class ForumParser
    include ParserHelper

    FORUM_XML = 'forum.xml'
    FORUM_MODULE_NAME = 'forum'

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      activity_dirs = activity_directories(@backup_dir, FORUM_MODULE_NAME)
      activity_dirs.map { |dir| parse_forum(dir) }
    end

    private

    def parse_forum(forum_dir)
      forum = Moodle2CC::Moodle2::Models::Forum.new
      activity_dir = File.join(@backup_dir, forum_dir)
      File.open(File.join(activity_dir, FORUM_XML)) do |f|
        forum_xml = Nokogiri::XML(f)
        forum.id = forum_xml.at_xpath('/activity/forum/@id').value
        forum.module_id = forum_xml.at_xpath('/activity/@moduleid').value
        forum.name = parse_text(forum_xml, '/activity/forum/name')
        forum.type = parse_text(forum_xml, '/activity/forum/type')
        forum.intro = parse_text(forum_xml, '/activity/forum/intro')
        forum.intro_format = parse_text(forum_xml, '/activity/forum/introformat')
        forum.assessed = parse_text(forum_xml, '/activity/forum/assessed')
        forum.assess_time_start = parse_text(forum_xml, '/activity/forum/assesstimestart')
        forum.assess_time_finish = parse_text(forum_xml, '/activity/forum/assesstimefinish')
        forum.scale = parse_text(forum_xml, '/activity/forum/scale')
        forum.max_bytes = parse_text(forum_xml, '/activity/forum/maxbytes')
        forum.max_attachments = parse_text(forum_xml, '/activity/forum/maxattachments')
        forum.force_subsscribe = parse_text(forum_xml, '/activity/forum/forcesubscribe')
        forum.tracking_type = parse_text(forum_xml, '/activity/forum/trackingtype')
        forum.rss_type = parse_text(forum_xml, '/activity/forum/rsstype')
        forum.rss_articles = parse_text(forum_xml, '/activity/forum/rssarticles')
        forum.time_modified = parse_text(forum_xml, '/activity/forum/timemodified')
        forum.warn_after = parse_text(forum_xml, '/activity/forum/warnafter')
        forum.block_after = parse_text(forum_xml, '/activity/forum/blockafter')
        forum.block_period = parse_text(forum_xml, '/activity/forum/blockperiod')
        forum.completion_discussions = parse_text(forum_xml, '/activity/forum/completiondiscussions')
        forum.completion_replies = parse_text(forum_xml, '/activity/forum/completionreplies')
        forum.completion_posts = parse_text(forum_xml, '/activity/forum/completionposts')
      end
      parse_module(activity_dir, forum)
      forum
    end

  end
end