module Moodle2CC::Moodle2::Models
  class Course
    attr_accessor :id_number, :fullname, :shortname, :startdate, :summary,
                  :course_id, :show_grades, :sections, :files, :pages, :forums, :assignments,
                  :books, :folders, :question_categories, :quizzes, :glossaries,
                  :labels, :resources, :external_urls, :choices, :questionnaires,
                  :feedbacks, :wikis, :grading_scales, :missing_files, :lti_links

    def initialize
      @sections = []
      @files = []
      @missing_files = []
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
      @wikis = []
      @grading_scales = {}
      @lti_links = []
    end

    def activities
      pages + forums + assignments + books + folders + quizzes + labels + resources + glossaries +
        external_urls + choices + questionnaires + feedbacks + wikis + lti_links
    end

  end
end