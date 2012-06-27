module Moodle2CC::Moodle
  class Course
    include HappyMapper

    tag 'COURSE'
    element :id, Integer, :tag => 'HEADER/ID'
    element :fullname, String, :tag => 'HEADER/FULLNAME'
    element :shortname, String, :tag => 'HEADER/SHORTNAME'
    element :startdate, Integer, :tag => 'HEADER/STARTDATE'
    element :visible, Boolean, :tag => 'HEADER/VISIBLE'
    has_many :sections, Section
    has_many :mods, Mod

    after_parse do |course|
      course.sections.each { |section| section.course = course }
      course.mods.each { |mod| mod.course = course }
    end
  end
end
