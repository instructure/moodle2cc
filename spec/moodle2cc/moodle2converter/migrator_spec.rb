require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::Migrator do
    subject(:migrator) { Moodle2Converter::Migrator.new('src_dir', 'out_dir') }
    let(:canvas_course) { CanvasCC::Model::Course.new }
    let(:canvas_module) { CanvasCC::Model::CanvasModule.new }
    let(:canvas_file) { CanvasCC::Model::CanvasFile.new }
    let(:canvas_page) { CanvasCC::Model::Page.new }
    let(:canvas_discussion) { CanvasCC::Assignment.new }
    let(:files) { [
        double('file_1', content_hash: 'a'),
        double('file_1', content_hash: 'a'),
        double('file_1', content_hash: 'b')
    ] }

    before(:each) do
      extractor = double('extractor', extract: nil)
      extractor.stub(:extract).and_yield(double('moodle_course',
                                                sections: [:section1, :section2],
                                                files: files,
                                                folders: [:folder1, :folder2],
                                                pages: [:page1, :page2],
                                                forums: [:forum1, :forum2]
                                         ))
      Moodle2::Extractor.stub(:new).and_return(extractor)
      Moodle2Converter::CourseConverter.any_instance.stub(:convert).and_return(canvas_course)
      Moodle2Converter::SectionConverter.any_instance.stub(:convert)
      Moodle2Converter::FileConverter.any_instance.stub(:convert)
      Moodle2Converter::PageConverter.any_instance.stub(:convert)
      Moodle2Converter::DiscussionConverter.any_instance.stub(:convert)
      Moodle2Converter::AssignmentConverter.any_instance.stub(:convert)
      Moodle2Converter::FolderConverter.any_instance.stub(:convert)
      CanvasCC::CartridgeCreator.stub(:new).and_return(double(create: nil))
    end

    describe '#migrate' do
      it 'converts courses' do
        converter = double(convert: canvas_course)
        Moodle2Converter::CourseConverter.stub(:new).and_return(converter)
        migrator.migrate
        expect(converter).to have_received(:convert)
      end

      it 'converts modules' do
        Moodle2Converter::SectionConverter.any_instance.stub(:convert).and_return('module')
        migrator.migrate
        expect(canvas_course.canvas_modules).to eq ['module', 'module']
      end

      it 'converts files' do
        Moodle2Converter::FileConverter.any_instance.stub(:convert).and_return('file')
        migrator.migrate
        expect(canvas_course.files).to eq ['file', 'file']
      end

      it 'converts pages' do
        Moodle2Converter::PageConverter.any_instance.stub(:convert).and_return('page')
        migrator.migrate
        expect(canvas_course.pages.compact).to eq ['page', 'page']
      end

      it 'converts discussions' do
        Moodle2Converter::DiscussionConverter.any_instance.stub(:convert).and_return('discussion')
        migrator.migrate
        expect(canvas_course.discussions).to eq ['discussion', 'discussion']
      end

<<<<<<< HEAD
=======
      it 'converts assignments' do
        Moodle2CC::Moodle2Converter::AssignmentConverter.any_instance.stub(:convert).and_return('assignment')
        migrator.migrate
        expect(canvas_course.assignments).to eq ['assignment', 'assignment']
      end

      it 'converts folders' do
        Moodle2CC::Moodle2Converter::FolderConverter.any_instance.stub(:convert).and_return('folder')
        migrator.migrate
        expect(canvas_course.pages.compact).to eq ['folder', 'folder']
      end

>>>>>>> Added folder converter with specs and added to migrator
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