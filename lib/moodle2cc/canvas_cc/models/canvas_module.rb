module Moodle2CC::CanvasCC::Models
  class CanvasModule

    attr_accessor :identifier, :title, :workflow_state, :module_items

    def initialize
      @module_items = []
    end

    def identifier=(identifier)
      @identifier = "module_#{Digest::MD5.hexdigest(identifier.to_s)}"
    end
  end
end