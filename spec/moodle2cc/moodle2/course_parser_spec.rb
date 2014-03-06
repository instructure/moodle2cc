require 'spec_helper'

module Moodle2CC::Moodle2
  describe CourseParser do

    it 'should parse a course' do
      course_parser = CourseParser.new(fixture_path(File.join('moodle2', 'backup')))
      course = course_parser.parse
      expect(course.id_number).to eq('sis_id_SC')
      expect(course.fullname).to eq('Sample Course')
      expect(course.shortname).to eq('SC')
      expect(course.startdate).to eq(Time.parse('Sat, 15 Feb 2014 00:00:00 GMT'))
      expect(course.summary).to eq('<p>This is my course summary</p>')
      expect(course.course_id).to eq('2')
    end

  end
end