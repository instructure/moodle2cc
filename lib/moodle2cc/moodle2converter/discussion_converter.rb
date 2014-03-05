module Moodle2CC::Moodle2Converter
  class DiscussionConverter


    def convert(forum)
      discussion = Moodle2CC::CanvasCC::Model::Discussion.new
      discussion.identifier = forum.id
      discussion.title = forum.name
      discussion.text = forum.intro
      discussion.discussion_type = 'threaded'

      discussion
    end

  end
end