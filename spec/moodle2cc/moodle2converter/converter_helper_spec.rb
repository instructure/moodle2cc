require 'spec_helper'

module Moodle2CC
  class DummyClass
    include Moodle2Converter::ConverterHelper
  end

  describe Moodle2Converter::ConverterHelper do
    subject { DummyClass.new }

    describe '#generate_unique_resource_path' do
      before(:each) do
        subject.stub(:generate_unique_identifier) { 'some_unique_hash' }
      end

      it 'generates a unique resource path' do
        path = subject.generate_unique_resource_path('my/base/path', 'name')

        expect(path).to eq 'my/base/path/some_unique_hash/name.html'
      end

      it 'uses the readable name' do
        path = subject.generate_unique_resource_path('my/base/path', 'A Readable Name')

        expect(path).to eq 'my/base/path/some_unique_hash/a-readable-name.html'
      end

      it 'appends the file extension' do
        path = subject.generate_unique_resource_path('my/base/path', 'name', 'html')

        expect(path).to eq 'my/base/path/some_unique_hash/name.html'
      end
    end

    describe '#generate_unique_identifier' do
      it 'generates a uuid prefixed with m2' do
        SecureRandom.stub(:uuid) { 'unique-id' }
        expect(subject.generate_unique_identifier).to eq 'm2uniqueid'
      end
    end

    describe '#generate_unique_identifier_for' do
      before(:each) { Digest::MD5.stub(:hexdigest) { 'hash' } }
      it 'hashes an id prefixed with m2' do
        expect(subject.generate_unique_identifier_for('some_id')).to eq 'm2hash'
        expect(Digest::MD5).to have_received(:hexdigest).with('some_id')
      end

      it 'accepts a suffix' do
        expect(subject.generate_unique_identifier_for('some_id', 'suffix')).to eq 'm2hashsuffix'
        expect(Digest::MD5).to have_received(:hexdigest).with('some_id')
      end
    end

    describe '#generate_unique_identifier_for_activity' do
      before (:each) { subject.stub(:generate_unique_identifier_for) }
      it 'generates a unique identifier for a page' do
        page = Moodle2CC::Moodle2::Models::Page.new
        page.id = 'id'

        subject.generate_unique_identifier_for_activity(page)

        expect(subject).to have_received(:generate_unique_identifier_for).with('id', '_page')
      end

      it 'generates a unique identifier for a Quiz' do
        quiz = Moodle2CC::Moodle2::Models::Quizzes::Quiz.new
        quiz.id = 'id'
        subject.generate_unique_identifier_for_activity(quiz)
        expect(subject).to have_received(:generate_unique_identifier_for).with('id', '_assessment')
      end

      it 'generates a unique identifier for an Assignment' do
        assignment = Moodle2CC::Moodle2::Models::Assignment.new
        assignment.id = 'id'
        subject.generate_unique_identifier_for_activity(assignment)
        expect(subject).to have_received(:generate_unique_identifier_for).with('id', '_assignment')
      end

      it 'generates a unique identifier for a Folder' do
        folder = Moodle2CC::Moodle2::Models::Folder.new
        folder.id = 'id'
        subject.generate_unique_identifier_for_activity(folder)
        expect(subject).to have_received(:generate_unique_identifier_for).with('id', '_folder')
      end

      it 'generates a unique identifier for a Forum' do
        forum = Moodle2CC::Moodle2::Models::Forum.new
        forum.id = 'id'
        subject.generate_unique_identifier_for_activity(forum)
        expect(subject).to have_received(:generate_unique_identifier_for).with('id', '_discussion')
      end

      it 'raises an exception for unknown activity types' do
        expect { subject.generate_unique_identifier_for_activity(nil) }.to raise_exception
      end
    end

    describe '#activity_content_type' do
      it 'looks up the content type for a page' do
        page = Moodle2CC::Moodle2::Models::Page.new
        expect(subject.activity_content_type(page)).to eq CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE
      end

      it 'looks up the content type for a Quiz' do
        quiz = Moodle2CC::Moodle2::Models::Quizzes::Quiz.new
        expect(subject.activity_content_type(quiz)).to eq CanvasCC::Models::ModuleItem::CONTENT_TYPE_QUIZ
      end

      it 'looks up the content type for an Assignment' do
        assignment = Moodle2CC::Moodle2::Models::Assignment.new
        expect(subject.activity_content_type(assignment)).to eq CanvasCC::Models::ModuleItem::CONTENT_TYPE_ASSIGNMENT
      end

      it 'looks up the content type for a Folder' do
        folder = Moodle2CC::Moodle2::Models::Folder.new
        expect(subject.activity_content_type(folder)).to eq CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE
      end

      it 'looks up the content type for a Forum' do
        forum = Moodle2CC::Moodle2::Models::Forum.new
        expect(subject.activity_content_type(forum)).to eq CanvasCC::Models::ModuleItem::CONTENT_TYPE_DISCUSSION_TOPIC
      end

      it 'looks up the content type for a Resource' do
        resource = Moodle2CC::Moodle2::Models::Resource.new
        expect(subject.activity_content_type(resource)).to eq CanvasCC::Models::ModuleItem::CONTENT_TYPE_ATTACHMENT
      end

      it 'raises an exception for unknown activity types' do
        expect { subject.activity_content_type(nil) }.to raise_exception
      end
    end

    describe '#workflow_state' do

      it 'returns "active" for true' do
        expect(subject.workflow_state(true)).to eq 'active'
      end

      it 'returns "unpublished" for false' do
        expect(subject.workflow_state(false)).to eq 'unpublished'
      end

    end


  end
end
