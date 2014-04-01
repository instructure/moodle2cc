require 'spec_helper'

module Moodle2CC::CanvasCC::Models
  describe Course do
    subject(:course) { Course.new }

    it_behaves_like 'it has an attribute for', :format
    it_behaves_like 'it has an attribute for', :copyright
    it_behaves_like 'it has an attribute for', :settings, {}
    it_behaves_like 'it has an attribute for', :resources, []
    it_behaves_like 'it has an attribute for', :canvas_modules, []
    it_behaves_like 'it has an attribute for', :files, []
    it_behaves_like 'it has an attribute for', :pages, []
    it_behaves_like 'it has an attribute for', :discussions, []
    it_behaves_like 'it has an attribute for', :assignments, []

    it 'formats date strings' do
      course.start_at = Time.parse('Sat, 08 Feb 2014 16:00:00 GMT')
      course.conclude_at = Time.parse('Sat, 10 Feb 2014 16:00:00 GMT')
      expect(course.start_at).to eq '2014-02-08T16:00:00'
      expect(course.conclude_at).to eq '2014-02-10T16:00:00'
    end

    it 'creates settings for unknown attributes' do
      course.title = 'course_title'
      expect(course.settings[:title]).to eq 'course_title'
    end

    describe '#all_resources' do
      it 'includes files and resources' do
        discussion = double('discussion', resources: [:discussion, :meta])
        assignment = double('assignment', resources: [:assignment])
        course.resources << :resource
        course.files << :file
        course.pages << :page
        course.discussions << discussion
        course.assignments << assignment
        expect(course.all_resources).to eq [:resource, :file, :page, :discussion, :meta, :assignment]
      end
    end

  end
end