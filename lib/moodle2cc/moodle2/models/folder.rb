module Moodle2CC::Moodle2::Models
  class Folder
    attr_accessor :id, :name, :intro, :intro_format, :revision, :file_ids

    def initialize
      @file_ids = []
    end
  end
end