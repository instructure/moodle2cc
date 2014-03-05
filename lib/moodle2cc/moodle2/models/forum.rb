module Moodle2CC::Moodle2::Models
class Forum

  attr_accessor :id, :module_id, :type, :name, :intro, :intro_format, :assessed, :assess_time_start, :assess_time_finish, :scale,
                :max_bytes, :max_attachments, :force_subsscribe, :tracking_type, :rss_type, :rss_articles,
                :time_modified, :warn_after, :block_after, :block_period, :completion_discussions, :completion_replies,
                :completion_posts

end
end