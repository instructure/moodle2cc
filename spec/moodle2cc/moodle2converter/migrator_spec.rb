require 'spec_helper'

describe Moodle2CC::Moodle2Converter::Migrator do
  subject(:migrator) { Moodle2CC::Moodle2Converter::Migrator.new('src_dir', 'out_dir') }
  let(:canvas_course) { Moodle2CC::CanvasCC::Model::Course.new }
  let(:canvas_module) { Moodle2CC::CanvasCC::Model::CanvasModule.new }
  let(:canvas_file) { Moodle2CC::CanvasCC::Model::CanvasFile.new }
  let(:canvas_page) { Moodle2CC::CanvasCC::Model::Page.new}
  let(:canvas_discussion) {Moodle2CC::CanvasCC::Discussion.new}

  before(:each) do
    extractor = double('extractor', extract: nil)
    extractor.stub(:extract).and_yield(double('moodle_course',
                                              sections: [:section1, :section2],
                                              files: [:file1, :file2],
                                              pages: [:page1, :page2],
                                              forums: [:forum1, :forum2]
                                       ))
    Moodle2CC::Moodle2::Extractor.stub(:new).and_return(extractor)
    Moodle2CC::Moodle2Converter::CourseConverter.any_instance.stub(:convert).and_return(canvas_course)
    Moodle2CC::Moodle2Converter::SectionConverter.any_instance.stub(:convert)
    Moodle2CC::Moodle2Converter::FileConverter.any_instance.stub(:convert)
    Moodle2CC::Moodle2Converter::PageConverter.any_instance.stub(:convert)
    Moodle2CC::Moodle2Converter::DiscussionConverter.any_instance.stub(:convert)
    Moodle2CC::CanvasCC::CartridgeCreator.stub(:new).and_return(double(create: nil))
  end

  describe '#migrate' do
    it 'converts courses' do
      converter = double(convert: canvas_course)
      Moodle2CC::Moodle2Converter::CourseConverter.stub(:new).and_return(converter)
      migrator.migrate
      expect(converter).to have_received(:convert)
    end

    it 'converts modules' do
      Moodle2CC::Moodle2Converter::SectionConverter.any_instance.stub(:convert).and_return('module')
      migrator.migrate
      expect(canvas_course.canvas_modules).to eq ['module', 'module']
    end

    it 'converts files' do
      Moodle2CC::Moodle2Converter::FileConverter.any_instance.stub(:convert).and_return('file')
      migrator.migrate
      expect(canvas_course.files).to eq ['file', 'file']
    end

    it 'converts pages' do
      Moodle2CC::Moodle2Converter::PageConverter.any_instance.stub(:convert).and_return('page')
      migrator.migrate
      expect(canvas_course.pages).to eq ['page', 'page']
    end

    it 'converts discussions' do
      Moodle2CC::Moodle2Converter::DiscussionConverter.any_instance.stub(:convert).and_return('discussion')
      migrator.migrate
      expect(canvas_course.discussions).to eq ['discussion', 'discussion']
    end

  end

  it 'sets the imscc_path' do
    Moodle2CC::CanvasCC::CartridgeCreator.stub(:new).and_return(double(create: 'out_dir'))
    migrator.migrate
    migrator.imscc_path.should == 'out_dir'
  end

end