require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::CourseConverter do

    it 'should convert a moodle course to a canvas course' do
      moodle_course = Moodle2::Models::Course.new
      moodle_course.fullname = 'Full Name'
      moodle_course.shortname = 'Short Name'
      moodle_course.startdate = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
      moodle_course.summary = 'Summary'
      moodle_course.course_id = 'course_id'
      cc_course = subject.convert(moodle_course)
      expect(cc_course.title).to eq('Full Name')
      expect(cc_course.course_code).to eq('Short Name')
      expect(cc_course.start_at).to eq('2014-02-08T16:00:00')
      expect(cc_course.identifier).to eq('m2ea134da7ce0152b54fb73853f6d62644_course')
      expect(cc_course.allow_student_discussion_topics).to be_false
      expect(cc_course.allow_student_wiki_edits).to be_false
      expect(cc_course.default_view).to eq 'modules'
    end

  end
end