module Moodle2CC::CanvasCC::Model
  class Page < Moodle2CC::CanvasCC::Model::Resource

    PAGE_ID_POSTFIX = '_PAGE'
    WIKI_CONTENT = 'wiki_content'

    EDITING_ROLE_TEACHER = 'teachers'

    attr_accessor :workflow_state, :editing_roles, :body, :title

    def initialize
      super
      @type = WEB_CONTENT_TYPE
    end

    def identifier=(identifier)
      @identifier = super(identifier) + PAGE_ID_POSTFIX
    end

    def page_name= name
      @title = name
      @href = "#{WIKI_CONTENT}/#{name.downcase.gsub(/\s/, '-')}.html"
    end

  end
end