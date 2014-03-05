module Moodle2CC::Moodle2::Models
class Course
  attr_accessor :id_number, :fullname, :shortname, :startdate, :summary, :course_id, :sections, :files, :pages, :forums,
                :assignments, :books

  def initialize
    @sections = []
    @files = []
    @pages = []
    @forums = []
    @assignments = []
    @books = []
  end

end
end