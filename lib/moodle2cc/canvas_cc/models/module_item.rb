module Moodle2CC::CanvasCC::Models
  class ModuleItem
    attr_accessor :identifier, :content_type, :workflow_state, :title,
                  :new_tab, :indent, :resource

    CONTENT_TYPE_WIKI_PAGE = 'WikiPage'
  end
end
