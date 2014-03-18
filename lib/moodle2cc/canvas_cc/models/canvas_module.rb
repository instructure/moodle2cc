module Moodle2CC::CanvasCC::Models
  class CanvasModule

    attr_accessor :identifier, :title, :workflow_state, :module_items

    def initialize
      @module_items = []
    end
  end
end