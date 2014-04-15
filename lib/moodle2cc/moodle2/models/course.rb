module Moodle2CC::Moodle2::Models
  class Course
    attr_accessor :id_number, :fullname, :shortname, :startdate, :summary,
                  :course_id, :sections, :files, :pages, :forums, :assignments,
                  :books, :folders, :question_categories, :quizzes, :glossaries,
                  :labels, :resources, :external_urls, :choices, :questionnaires,
                  :feedbacks

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
      @choices = []
      @feedbacks = []
      @questionnaires = []
      @glossaries = []
      @labels = []
      @resources = []
      @external_urls = []
    end

    def activities
      pages + forums + assignments + books + folders + quizzes + labels + resources + glossaries +
        external_urls + choices + questionnaires + feedbacks
    end

  end
end