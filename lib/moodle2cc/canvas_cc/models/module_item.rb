module Moodle2CC::CanvasCC::Models
  class ModuleItem
    attr_accessor :identifier, :content_type, :workflow_state, :title,
                  :new_tab, :indent, :resource, :identifierref

    CONTENT_TYPE_WIKI_PAGE = 'WikiPage'
    CONTENT_TYPE_ATTACHMENT = 'Attachment'
    CONTENT_TYPE_CONTEXT_MODULE_SUB_HEADER = 'ContextModuleSubHeader'
    CONTENT_TYPE_DISCUSSION_TOPIC = 'DiscussionTopic'
    CONTENT_TYPE_ASSIGNMENT = 'Assignment'
    CONTENT_TYPE_CONTEXT_EXTERNAL_TOOL = 'ContextExternalTool'
    CONTENT_TYPE_QUIZ = 'Quizzes::Quiz'

  end
end
