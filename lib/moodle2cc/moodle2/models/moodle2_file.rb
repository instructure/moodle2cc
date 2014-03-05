module Moodle2CC::Moodle2::Models
  class Moodle2File

    attr_accessor :id, :content_hash, :context_id, :component, :file_area, :item_id, :file_path, :file_name,
                  :user_id, :file_size, :mime_type, :status, :time_created, :time_modified, :source, :author,
                  :license, :sort_order, :repository_type, :repository_id, :reference, :file_location

    def file_size=(size)
      @file_size = Integer(size)
    end

  end
end