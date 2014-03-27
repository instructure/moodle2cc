require 'spec_helper'

module Moodle2CC::Moodle2::Models
  describe Course do

    it_behaves_like 'it has an attribute for', :id_number
    it_behaves_like 'it has an attribute for', :fullname
    it_behaves_like 'it has an attribute for', :shortname
    it_behaves_like 'it has an attribute for', :startdate
    it_behaves_like 'it has an attribute for', :summary
    it_behaves_like 'it has an attribute for', :course_id
    it_behaves_like 'it has an attribute for', :folders, []
    it_behaves_like 'it has an attribute for', :glossaries, []
    it_behaves_like 'it has an attribute for', :question_categories, []
    it_behaves_like 'it has an attribute for', :labels, []

    describe '#activities' do
      it 'collects pages' do
        subject.pages << :page
        expect(subject.activities).to eq [:page]
      end

      it 'collects forums' do
        subject.forums << :forums
        expect(subject.activities).to eq [:forums]
      end

      it 'collects assignments' do
        subject.assignments << :assignment
        expect(subject.activities).to eq [:assignment]
      end

      it 'collects books' do
        subject.books << :book
        expect(subject.activities).to eq [:book]
      end

      it 'collects folders' do
        subject.folders << :folder
        expect(subject.activities).to eq [:folder]
      end
    end
  end
end

