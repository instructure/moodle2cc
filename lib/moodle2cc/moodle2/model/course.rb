module Moodle2CC::Moodle2::Model 
class Course
  attr_accessor :id_number, :fullname, :shortname, :startdate, :summary, :course_id, :sections, :files, :pages, :forums,
                :assignments

  def initialize
    @sections = []
    @files = []
    @pages = []
    @forums = []
    @assignments = []
  end

end
end