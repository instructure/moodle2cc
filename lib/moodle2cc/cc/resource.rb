module Moodle2CC::CC
  module Resource
    def self.included(klass)
      klass.class_eval do
        attr_accessor :mod
      end
    end

    def initialize(mod, *args)
      @mod = mod
    end

    def identifier
      @identifier ||= create_key("#{@mod.mod_type}_#{@mod.id}", 'resource_')
    end
  end
end
