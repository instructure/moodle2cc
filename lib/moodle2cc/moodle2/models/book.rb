module Moodle2CC::Moodle2::Models
  class Book
    attr_accessor :id, :name, :intro, :numbering, :custom_titles, :chapters, :intro_format

    def initialize
      @chapters = []
    end
  end
end