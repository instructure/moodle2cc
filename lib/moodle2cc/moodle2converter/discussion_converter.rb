module Moodle2CC::Moodle2Converter
  class DiscussionConverter
    include ConverterHelper


    def convert(forum)
      discussion = Moodle2CC::CanvasCC::Models::Discussion.new
      discussion.identifier = generate_unique_identifier_for(forum.id, DISCUSSION_SUFFIX)
      discussion.title = truncate_text(forum.name)
      discussion.text = forum.intro
      discussion.discussion_type = 'threaded'
      discussion.workflow_state = workflow_state(forum.visible)
      discussion.require_initial_post = (forum.type == 'qanda')
      discussion
    end

  end
end