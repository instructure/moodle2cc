require 'spec_helper'

describe Moodle2CC::Moodle2::Extractor do
  subject(:extractor) { Moodle2CC::Moodle2::Extractor.new('path_to_zip') }
  let(:course) { Moodle2CC::Moodle2::Models::Course.new }

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
    Moodle2CC::Moodle2::Parsers::QuestionCategoryParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::QuizParser.any_instance.stub(:parse)
    Moodle2CC::Moodle2::Parsers::GlossaryParser.any_instance.stub(:parse)
    Zip::File.stub(:open).and_yield([])
  end

  it 'parses courses' do
    allow(course).to receive(:name) { 'course double' }
    Moodle2CC::Moodle2::Parsers::CourseParser.any_instance.stub(:parse).and_return(course)
    extractor.extract { |parsed_course| expect(parsed_course.name).to eq 'course double' }
  end

  it 'parses sections' do
    section = Moodle2CC::Moodle2::Models::Section.new
    Moodle2CC::Moodle2::Parsers::SectionParser.any_instance.stub(:parse).and_return([section])
    extractor.extract {}

    expect(course.sections).to eq [section]
  end

  it 'associates activities with sections based on their sequence' do
    section = Moodle2CC::Moodle2::Models::Section.new
    section.sequence = [2, 1]
    Moodle2CC::Moodle2::Parsers::SectionParser.any_instance.stub(:parse).and_return([section])

    activity1 = double(module_id: '1')
    activity2 = double(module_id: '2')
    activity3 = double(module_id: '3')
    course.stub(:activities).and_return([activity1, activity2, activity3])

    extractor.extract {}

    expect(section.activities.size).to eq 2
    expect(section.activities[0]).to eq activity2
    expect(section.activities[1]).to eq activity1
  end

  it 'parses files' do
    Moodle2CC::Moodle2::Parsers::FileParser.any_instance.stub(:parse).and_return(['file'])
    extractor.extract {}
    expect(course.files).to eq ['file']
  end

  it 'parses pages' do
    page = Moodle2CC::Moodle2::Models::Page.new
    Moodle2CC::Moodle2::Parsers::PageParser.any_instance.stub(:parse).and_return([page])
    extractor.extract {}
    expect(course.pages).to eq [page]
  end

  it 'parses forums' do
    forum = Moodle2CC::Moodle2::Models::Forum.new
    Moodle2CC::Moodle2::Parsers::ForumParser.any_instance.stub(:parse).and_return([forum])
    extractor.extract {}
    expect(course.forums).to eq [forum]
  end

  it 'parses assignments' do
    assignment = Moodle2CC::Moodle2::Models::Assignment.new
    Moodle2CC::Moodle2::Parsers::AssignmentParser.any_instance.stub(:parse).and_return([assignment])
    extractor.extract {}
    expect(course.assignments).to eq [assignment]
  end

  it 'parses books' do
    book = Moodle2CC::Moodle2::Models::Book.new
    Moodle2CC::Moodle2::Parsers::BookParser.any_instance.stub(:parse).and_return([book])
    extractor.extract {}
    expect(course.books).to eq [book]
  end

  it 'parses folders' do
    folder = Moodle2CC::Moodle2::Models::Folder.new
    Moodle2CC::Moodle2::Parsers::FolderParser.any_instance.stub(:parse).and_return([folder])
    extractor.extract {}
    expect(course.folders).to eq [folder]
  end

  it 'parses quiz questions' do
    Moodle2CC::Moodle2::Models::Quizzes::QuestionCategory.any_instance.stub(:resolve_embedded_question_references)
    question_category = Moodle2CC::Moodle2::Models::Quizzes::QuestionCategory.new
    Moodle2CC::Moodle2::Parsers::QuestionCategoryParser.any_instance.stub(:parse).and_return([question_category])
    extractor.extract {}
    expect(course.question_categories).to eq [question_category]
    expect(question_category).to have_received(:resolve_embedded_question_references).exactly(1)
  end

  it 'parses quizzes' do
    quiz = Moodle2CC::Moodle2::Models::Quizzes::Quiz.new
    Moodle2CC::Moodle2::Parsers::QuizParser.any_instance.stub(:parse).and_return([quiz])
    extractor.extract {}
    expect(course.quizzes).to eq [quiz]
  end

  it 'parses glossaries' do
    glossary = Moodle2CC::Moodle2::Models::Glossary.new
    Moodle2CC::Moodle2::Parsers::GlossaryParser.any_instance.stub(:parse).and_return([glossary])
    extractor.extract {}
    expect(course.glossaries).to eq [glossary]
  end

end