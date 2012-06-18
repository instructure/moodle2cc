module Moodle2CC::CC
  class Resource
    include CCHelper

    attr_accessor :identifier, :type, :href, :intendeduse, :files, :dependency

    def initialize
      @files = []
    end

    def self.from_manifest(manifest)
    end
  end
end
