module Moodle2CC::Moodle2::Models
  class Course
    attr_accessor :id_number, :fullname, :shortname, :startdate, :summary, :course_id, :sections, :files, :pages, :forums,
                  :assignments, :books, :folders

    def initialize
      @sections = []
      @files = []
      @pages = []
      @forums = []
      @assignments = []
      @books = []
      @folders = []
    end

    def activities
      pages + forums + assignments + books + folders
    end

  end
end