module Moodle2CC::Moodle2::Models
  class Resource
    attr_accessor :id, :module_id, :name, :intro, :intro_format, :to_be_migrated, :legacy_files, :legacy_files_last,
                  :display, :display_options, :filter_files, :file_ids, :visible, :file

    def initialize
      @file_ids = []
    end

  end
end