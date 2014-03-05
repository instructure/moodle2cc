require 'spec_helper'

describe Moodle2CC::Moodle2::Extractor do
  subject(:extractor) { Moodle2CC::Moodle2::Extractor.new('path_to_zip') }
  let(:course) { double(sections: [], :sections= => [],
                        files: [], :files= => [],
                        :pages => [], :pages= => [],
                        :forums => [], :forums= => [],
                        :assignments => [], :assignments= => []
  )}

  before(:each) do
    Dir.stub(:mktmpdir).and_yield('work_dir')
    Moodle2CC::Moodle2::Parsers::CourseParser.any_instance.stub(:parse).and_return(course)
    Moodle2CC::Moodle2::Parsers::SectionParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::FileParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::PageParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::ForumParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::AssignmentParser.any_instance.stub(:parse)
    Zip::File.stub(:open).and_yield([])
  end

  it 'parses courses' do
    allow(course).to receive(:name) { 'course double' }
    Moodle2CC::Moodle2::Parsers::CourseParser.any_instance.stub(:parse).and_return(course)
    extractor.extract { |parsed_course| expect(parsed_course.name).to eq 'course double' }
  end

  it 'parses sections' do
    Moodle2CC::Moodle2::Parsers::SectionParser.any_instance.stub(:parse).and_return(['module'])
    extractor.extract {}
    expect(course).to have_received(:sections=).with(['module'])
  end

  it 'parses files' do
    Moodle2CC::Moodle2::Parsers::FileParser.any_instance.stub(:parse).and_return(['file'])
    extractor.extract {}
    expect(course).to have_received(:files=).with(['file'])
  end

  it 'parsed pages' do
    Moodle2CC::Moodle2::Parsers::PageParser.any_instance.stub(:parse).and_return(['page'])
    extractor.extract {}
    expect(course).to have_received(:pages=).with(['page'])
  end

  it 'parsed forums' do
    Moodle2CC::Moodle2::Parsers::ForumParser.any_instance.stub(:parse).and_return(['forum'])
    extractor.extract {}
    expect(course).to have_received(:forums=).with(['forum'])
  end

  it 'parsed assignments' do
    Moodle2CC::Moodle2::Parsers::AssignmentParser.any_instance.stub(:parse).and_return(['assign'])
    extractor.extract {}
    expect(course).to have_received(:assignments=).with(['assign'])
  end

end