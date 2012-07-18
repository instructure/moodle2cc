module Moodle2CC::CC
  class Course
    include CCHelper

    attr_accessor :format

    def initialize(course)
      @format = case course.format
                when 'weeks', 'weekscss'
                  'Week'
                else
                  'Topic'
                end
    end
  end
end
