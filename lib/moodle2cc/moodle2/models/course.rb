module Moodle2CC::Moodle2::Models
  class Course
    attr_accessor :id_number, :fullname, :shortname, :startdate, :summary, :course_id, :sections, :files, :pages, :forums,
                  :assignments, :books, :folders, :question_categories, :quizzes, :glossaries

    def initialize
      @sections = []
      @files = []
      @pages = []
      @forums = []
      @assignments = []
      @books = []
      @folders = []
      @question_categories = []
      @quizzes = []
      @glossaries = []
    end

    def activities
      pages + forums + assignments + books + folders + quizzes
    end

  end
end