module Moodle2CC::Moodle2::Models
  class Course
    attr_accessor :id_number, :fullname, :shortname, :startdate, :summary, :course_id, :sections, :files, :pages, :forums,
                  :assignments, :books, :folders, :question_categories, :quizzes, :glossaries, :labels

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
      @labels = []
    end

    def activities
      pages + forums + assignments + books + folders + quizzes + labels
    end

  end
end