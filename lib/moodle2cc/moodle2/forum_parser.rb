class Moodle2CC::Moodle2::ForumParser

  FORUM_XML = 'forum.xml'
  NULL_XML_VALUE = '$@NULL@$'

  def initialize(backup_dir)
    @backup_dir = backup_dir
  end

  def parse
    activity_dirs = parse_moodle_backup
    activity_dirs.map {|dir| parse_forum(dir)}
  end

  private

  def parse_moodle_backup
    File.open(File.join(@backup_dir, Moodle2CC::Moodle2::Extractor::MOODLE_BACKUP_XML)) do |f|
      moodle_backup_xml = Nokogiri::XML(f)
      activities = moodle_backup_xml./('/moodle_backup/information/contents/activities').xpath('activity[modulename = "forum"]')
      activities.map { |forum| forum./('directory').text }
    end
  end

  def parse_forum(forum_dir)
    forum = Moodle2CC::Moodle2::Model::Forum.new
    File.open(File.join(@backup_dir, forum_dir, FORUM_XML)) do |f|
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
    forum
  end


  def parse_text(node, xpath)
    if v_node = node.%(xpath)
      value = v_node.text
      value unless value == NULL_XML_VALUE
    end
  end

end