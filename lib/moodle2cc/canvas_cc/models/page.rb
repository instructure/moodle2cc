module Moodle2CC::CanvasCC::Models
  class Page < Moodle2CC::CanvasCC::Models::Resource

    PAGE_ID_POSTFIX = '_PAGE'
    WIKI_CONTENT = 'wiki_content'
    BOOK_PATH = WIKI_CONTENT + '/books'

    EDITING_ROLE_TEACHER = 'teachers'

    attr_accessor :workflow_state, :editing_roles, :body, :title

    def initialize
      super
      @type = WEB_CONTENT_TYPE
    end

    def identifier=(identifier)
      @identifier = identifier
    end

    def identifier
      @identifier
    end

    def page_name= name
      @title = name
      @href = "#{WIKI_CONTENT}/#{self.class.convert_name_to_url(name)}.html"
    end

    def self.convert_name_to_url(name)
      CGI::escape(name.downcase.gsub(/\s/, '-').gsub('.', 'dot'))
    end

  end
end