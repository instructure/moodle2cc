module Moodle2CC::Moodle
  class Course
    include HappyMapper

    tag 'COURSE'
    element :id, Integer, :tag => 'HEADER/ID'
    element :fullname, String, :tag => 'HEADER/FULLNAME'
    element :shortname, String, :tag => 'HEADER/SHORTNAME'
    element :startdate, Integer, :tag => 'HEADER/STARTDATE'
    element :format, String, :tag => 'HEADER/FORMAT'
    element :visible, Boolean, :tag => 'HEADER/VISIBLE'
    has_many :sections, Section
    has_many :mods, Mod
    has_many :grade_items, GradeItem
    has_many :question_categories, QuestionCategory

    after_parse do |course|
      course.sections.each do |section|
        section.course = course
        mod = section.mods.find { |mod| mod.mod_type == 'summary' }
        course.mods << mod.instance if mod
      end
      course.mods.each { |mod| mod.course = course }
      course.grade_items.each { |grade_item| grade_item.course = course }
      course.question_categories.each { |question_category| question_category.course = course }
    end
  end
end
