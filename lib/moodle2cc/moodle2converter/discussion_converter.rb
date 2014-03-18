module Moodle2CC::Moodle2Converter
  class DiscussionConverter
    include ConverterHelper


    def convert(forum)
      discussion = Moodle2CC::CanvasCC::Models::Discussion.new
      discussion.identifier = generate_unique_identifier_for(forum.id, DISCUSSION_SUFFIX)
      discussion.title = forum.name
      discussion.text = forum.intro
      discussion.discussion_type = 'threaded'

      discussion
    end

  end
end