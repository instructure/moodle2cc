require 'spec_helper'

describe Moodle2CC::Moodle2::Extractor do
  subject(:extractor) { Moodle2CC::Moodle2::Extractor.new('path_to_zip') }
  let(:course) { Moodle2CC::Moodle2::Models::Course.new }
  let(:section) { Moodle2CC::Moodle2::Models::Section.new }
  let(:book) { Moodle2CC::Moodle2::Models::Book.new }

  before(:each) do
    Dir.stub(:mktmpdir).and_yield('work_dir')
    Moodle2CC::Moodle2::Parsers::CourseParser.any_instance.stub(:parse).and_return(course)
    Moodle2CC::Moodle2::Parsers::SectionParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::FileParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::PageParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::ForumParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::AssignmentParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::BookParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::FolderParser.any_instance.stub(:parse)
    Zip::File.stub(:open).and_yield([])
  end

  it 'parses courses' do
    allow(course).to receive(:name) { 'course double' }
    Moodle2CC::Moodle2::Parsers::CourseParser.any_instance.stub(:parse).and_return(course)
    extractor.extract { |parsed_course| expect(parsed_course.name).to eq 'course double' }
  end

  it 'parses sections' do
    section.sequence = [1, 2]
    Moodle2CC::Moodle2::Parsers::SectionParser.any_instance.stub(:parse).and_return([section])
    extractor.extract {}

    expect(course.sections).to eq [section]
  end

  it 'parses files' do
    Moodle2CC::Moodle2::Parsers::FileParser.any_instance.stub(:parse).and_return(['file'])
    extractor.extract {}
    expect(course.files).to eq ['file']
  end

  it 'parsed pages' do
    Moodle2CC::Moodle2::Parsers::PageParser.any_instance.stub(:parse).and_return(['page'])
    extractor.extract {}
    expect(course.pages).to eq ['page']
  end

  it 'parsed forums' do
    Moodle2CC::Moodle2::Parsers::ForumParser.any_instance.stub(:parse).and_return(['forum'])
    extractor.extract {}
    expect(course.forums).to eq ['forum']
  end

  it 'parsed assignments' do
    Moodle2CC::Moodle2::Parsers::AssignmentParser.any_instance.stub(:parse).and_return(['assign'])
    extractor.extract {}
    expect(course.assignments).to eq ['assign']
  end

  it 'parses books' do
    Moodle2CC::Moodle2::Parsers::BookParser.any_instance.stub(:parse).and_return(['book'])
    extractor.extract {}
    expect(course.books).to eq ['book']
  end

  it 'parses folders' do
    Moodle2CC::Moodle2::Parsers::FolderParser.any_instance.stub(:parse).and_return(['folder'])
    extractor.extract {}
    expect(course.folders).to eq ['folder']
  end

end