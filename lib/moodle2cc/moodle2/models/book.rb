module Moodle2CC::Moodle2::Models
  class Book
    attr_accessor :id, :module_id, :name, :intro, :numbering, :custom_titles, :chapters, :intro_format, :visible

    def initialize
      @chapters = []
    end
  end
end