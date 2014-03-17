module Moodle2CC::CanvasCC::Models
  class CanvasFile < Moodle2CC::CanvasCC::Models::Resource

    WEB_RESOURCES = 'web_resources'
    FILE_ID_POSTFIX = '_FILE'

    attr_reader :file_path
    attr_accessor :file_location

    def initialize
      super
      @type = WEB_CONTENT_TYPE
    end

    def file_path=(file_path)
      @href = "#{WEB_RESOURCES}/#{file_path}"
      @files << self.href
      @file_path = file_path
    end

    def identifier=(ident)
      @identifier = super(ident) + FILE_ID_POSTFIX
    end

  end
end