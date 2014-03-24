require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::Migrator do
    subject(:migrator) { Moodle2Converter::Migrator.new('src_dir', 'out_dir') }
    let(:canvas_course) { CanvasCC::Models::Course.new }

    let(:moodle_course) { Moodle2CC::Moodle2::Models::Course.new }
    let(:canvas_page) { Moodle2CC::CanvasCC::Models::Page.new }
    let(:canvas_discussion) {Moodle2CC::CanvasCC::Models::Discussion.new}
    let(:canvas_assignment) {Moodle2CC::CanvasCC::Models::Assignment.new}
    let(:canvas_assessment) {Moodle2CC::CanvasCC::Models::Assessment.new}

    before(:each) do
      extractor = double('extractor', extract: nil)

      extractor.stub(:extract).and_yield(moodle_course)

      Moodle2::Extractor.stub(:new).and_return(extractor)
      Moodle2Converter::CourseConverter.any_instance.stub(:convert).and_return(canvas_course)
      Moodle2Converter::HomepageConverter.any_instance.stub(:convert).and_return(canvas_page)
      Moodle2Converter::SectionConverter.any_instance.stub(:convert)
      Moodle2Converter::FileConverter.any_instance.stub(:convert)
      Moodle2Converter::PageConverter.any_instance.stub(:convert)
      Moodle2Converter::DiscussionConverter.any_instance.stub(:convert)
      Moodle2Converter::AssignmentConverter.any_instance.stub(:convert)
      Moodle2Converter::FolderConverter.any_instance.stub(:convert)
      Moodle2Converter::BookConverter.any_instance.stub(:convert_to_pages)
      Moodle2Converter::HtmlConverter.stub(:new) { double('html_converter', convert: true) }
      CanvasCC::CartridgeCreator.stub(:new).and_return(double(create: nil))
    end

    describe '#migrate' do
      it 'converts courses' do
        converter = double(convert: canvas_course)
        Moodle2Converter::CourseConverter.stub(:new).and_return(converter)
        migrator.migrate
        expect(converter).to have_received(:convert)
      end

      it 'converts course home page' do
        moodle_course.sections = [:section1, :section2]
        converter_mock = double(convert: canvas_page)
        Moodle2Converter::HomepageConverter.stub(:new).and_return(converter_mock)

        migrator.migrate

        expect(converter_mock).to have_received(:convert).with(:section1)
        expect(canvas_course.pages).to eq [canvas_page]
      end

      it 'converts all but the first section into modules' do
        moodle_course.sections = [:section1, :section2, :section3]
        Moodle2Converter::SectionConverter.any_instance.stub(:convert).and_return('module')
        migrator.migrate

        expect(canvas_course.canvas_modules).to eq ['module', 'module']
      end

      it 'converts files' do
        files = [
          double('file_1', content_hash: 'a'),
          double('file_1', content_hash: 'a'),
          double('file_1', content_hash: 'b')
        ]
        moodle_course.files = files
        Moodle2Converter::FileConverter.any_instance.stub(:convert).and_return('file')
        migrator.migrate
        expect(canvas_course.files).to eq ['file', 'file']
      end

      it 'converts pages' do
        moodle_course.pages = [:page1, :page2]
        Moodle2Converter::PageConverter.any_instance.stub(:convert).and_return(canvas_page)
        migrator.migrate
        expect(canvas_course.pages.compact).to eq [canvas_page, canvas_page]
      end

      it 'converts discussions' do
        moodle_course.forums = [:discussion1, :discussion2]
        Moodle2Converter::DiscussionConverter.any_instance.stub(:convert).and_return(canvas_discussion)
        migrator.migrate
        expect(canvas_course.discussions).to eq [canvas_discussion, canvas_discussion]
      end

      it 'converts assignments' do
        moodle_course.assignments = [:assign1, :assign2]
        Moodle2CC::Moodle2Converter::AssignmentConverter.any_instance.stub(:convert).and_return(canvas_assignment)
        migrator.migrate
        expect(canvas_course.assignments).to eq [canvas_assignment, canvas_assignment]
      end

      it 'converts folders' do
        moodle_course.folders = [:folder1, :folder2]
        Moodle2CC::Moodle2Converter::FolderConverter.any_instance.stub(:convert).and_return(canvas_page)
        migrator.migrate
        expect(canvas_course.pages.compact).to eq [canvas_page, canvas_page]
      end

      it 'converts books' do
        moodle_course.books = [:book1, :book2]
        Moodle2CC::Moodle2Converter::BookConverter.any_instance.stub(:convert_to_pages).and_return([canvas_page])
        migrator.migrate

        expect(canvas_course.pages.compact).to eq [canvas_page, canvas_page]
      end

      context "html conversion" do
        let(:converter){double('invitation', :convert => 'converted_html')}

        before(:each) do
          Moodle2CC::Moodle2Converter::HtmlConverter.stub(:new).and_return(converter)
        end

        it 'converts pages' do
          canvas_course.pages = [Moodle2CC::CanvasCC::Models::Page.new, Moodle2CC::CanvasCC::Models::Page.new]
          migrator.migrate
          expect(converter).to have_received(:convert).exactly(2)
          canvas_course.pages.each{|page| expect(page.body).to eq 'converted_html'}
        end

        it 'converts discussions' do
          canvas_course.discussions = [Moodle2CC::CanvasCC::Models::Discussion.new, Moodle2CC::CanvasCC::Models::Discussion.new]
          migrator.migrate
          expect(converter).to have_received(:convert).exactly(2)
          canvas_course.discussions.each{|discussion| expect(discussion.text).to eq 'converted_html'}
        end

        it 'converts discussions' do
          canvas_course.assignments = [Moodle2CC::CanvasCC::Models::Assignment.new, Moodle2CC::CanvasCC::Models::Assignment.new]
          migrator.migrate
          expect(converter).to have_received(:convert).exactly(2)
          canvas_course.assignments.each{|assignment| expect(assignment.body).to eq 'converted_html'}
        end

        it 'converts assessment' do
          canvas_course.assessments = [Moodle2CC::CanvasCC::Models::Assessment.new, Moodle2CC::CanvasCC::Models::Assessment.new]
          migrator.migrate
          expect(converter).to have_received(:convert).exactly(2)
          canvas_course.assessments.each{|assessment| expect(assessment.description).to eq 'converted_html'}
        end

      end
    end

    it 'sets the imscc_path' do
      CanvasCC::CartridgeCreator.stub(:new).and_return(double(create: 'out_dir'))
      migrator.migrate
      migrator.imscc_path.should == 'out_dir'
    end

    it 'converts assignments' do
      Moodle2CC::Moodle2Converter::AssignmentConverter.any_instance.stub(:convert).and_return('assignment')
      migrator.migrate
      expect(canvas_course.assignments).to eq ['assignment', 'assignment']
    end

  end
end