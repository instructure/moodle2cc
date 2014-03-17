module Moodle2CC::CanvasCC::Models
  class Resource

    WEB_CONTENT_TYPE = 'webcontent'

    attr_accessor :files, :href, :type, :dependencies, :ident_postfix

    def initialize
      @files = []
      @dependencies = []
      @ident_postfix = ''
    end

    def identifier=(ident)
      @identifier = "CC_#{Digest::MD5.hexdigest(ident.to_s)}"
    end

    def identifier
      @identifier + @ident_postfix.to_s
    end

    def attributes
      {
        href: href,
        type: type,
        identifier: identifier
      }.delete_if { |_, v| v.nil? }
    end

  end
end