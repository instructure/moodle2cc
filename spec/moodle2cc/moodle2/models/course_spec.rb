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
    it_behaves_like 'it has an attribute for', :external_urls, []
    it_behaves_like 'it has an attribute for', :resources, []
    it_behaves_like 'it has an attribute for', :lti_links, []

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

      it 'collects labels' do
        subject.labels << :labels
        expect(subject.activities).to eq [:labels]
      end

      it 'collect glossaries' do
        subject.glossaries << :glossaries
        expect(subject.activities).to eq [:glossaries]
      end

      it 'collect external_urls' do
        subject.external_urls << :external_urls
        expect(subject.activities).to eq [:external_urls]
      end

      it 'collects resources' do
        subject.resources << :resources
        expect(subject.activities).to eq [:resources]
      end
    end
  end
end

