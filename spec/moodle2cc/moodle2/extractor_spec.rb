require 'spec_helper'

module Moodle2CC::Moodle2
  describe Extractor do
    subject(:extractor) { Extractor.new('path_to_zip') }
    let(:course) { Models::Course.new }

    before(:each) do
      Dir.stub(:mktmpdir).and_yield('work_dir')
      Parsers::CourseParser.any_instance.stub(:parse).and_return(course)
      Parsers::SectionParser.any_instance.stub(:parse)
      Parsers::FileParser.any_instance.stub(:parse)
      Parsers::PageParser.any_instance.stub(:parse)
      Parsers::WikiParser.any_instance.stub(:parse)
      Parsers::ForumParser.any_instance.stub(:parse)
      Parsers::AssignmentParser.any_instance.stub(:parse)
      Parsers::BookParser.any_instance.stub(:parse)
      Parsers::FolderParser.any_instance.stub(:parse)
      Parsers::QuestionCategoryParser.any_instance.stub(:parse)
      Parsers::QuizParser.any_instance.stub(:parse)
      Parsers::ChoiceParser.any_instance.stub(:parse)
      Parsers::FeedbackParser.any_instance.stub(:parse)
      Parsers::QuestionnaireParser.any_instance.stub(:parse)
      Parsers::GlossaryParser.any_instance.stub(:parse)
      Parsers::LabelParser.any_instance.stub(:parse)
      Parsers::ExternalUrlParser.any_instance.stub(:parse)
      Parsers::ResourceParser.any_instance.stub(:parse)
      Parsers::LtiParser.any_instance.stub(:parse)
      Zip::File.stub(:open).and_yield([])
    end

    it 'parses courses' do
      allow(course).to receive(:name) { 'course double' }
      Parsers::CourseParser.any_instance.stub(:parse).and_return(course)
      extractor.extract { |parsed_course| expect(parsed_course.name).to eq 'course double' }
    end

    it 'parses sections' do
      section = Models::Section.new
      Parsers::SectionParser.any_instance.stub(:parse).and_return([section])
      extractor.extract {}

      expect(course.sections).to eq [section]
    end

    it 'associates activities with sections based on their sequence' do
      section = Models::Section.new
      section.sequence = [2, 1]
      Parsers::SectionParser.any_instance.stub(:parse).and_return([section])

      activity1 = double(module_id: '1')
      activity2 = double(module_id: '2')
      activity3 = double(module_id: '3')
      course.stub(:activities).and_return([activity1, activity2, activity3])

      extractor.extract {}

      expect(section.activities.size).to eq 2
      expect(section.activities[0]).to eq activity2
      expect(section.activities[1]).to eq activity1
    end

    it 'associates activities with sections based on their sequence' do
      section = Models::Section.new
      section.sequence = [2, 1]
      Parsers::SectionParser.any_instance.stub(:parse).and_return([section])

      activity1 = double(module_id: '1')
      activity2 = double(module_id: '2')
      activity3 = double(module_id: '3')
      course.stub(:activities).and_return([activity1, activity2, activity3])

      extractor.extract {}

      expect(section.activities.size).to eq 2
      expect(section.activities[0]).to eq activity2
      expect(section.activities[1]).to eq activity1
    end

    it 'associates resources with their files' do
      resource = Models::Resource.new
      resource.file_ids = [1,3]
      Parsers::ResourceParser.any_instance.stub(:parse).and_return([resource])

      file = Models::Moodle2File.new
      file.id = 3
      course.stub(:files).and_return([file])

      extractor.extract {}

      expect(resource.file).to eq file
    end

    it 'parses files' do
      file = Models::Moodle2File.new
      Parsers::FileParser.any_instance.stub(:parse).and_return([[file], []])
      extractor.extract {}
      expect(course.files).to eq [file]
    end

    it 'parses pages' do
      page = Models::Page.new
      Parsers::PageParser.any_instance.stub(:parse).and_return([page])
      extractor.extract {}
      expect(course.pages).to eq [page]
    end

    it 'parses wikis' do
      wiki = Models::Wiki.new
      Parsers::WikiParser.any_instance.stub(:parse).and_return([wiki])
      extractor.extract {}
      expect(course.wikis).to eq [wiki]
    end

    it 'parses forums' do
      forum = Models::Forum.new
      Parsers::ForumParser.any_instance.stub(:parse).and_return([forum])
      extractor.extract {}
      expect(course.forums).to eq [forum]
    end

    it 'parses assignments' do
      assignment = Models::Assignment.new
      Parsers::AssignmentParser.any_instance.stub(:parse).and_return([assignment])
      extractor.extract {}
      expect(course.assignments).to eq [assignment]
    end

    it 'parses books' do
      book = Models::Book.new
      Parsers::BookParser.any_instance.stub(:parse).and_return([book])
      extractor.extract {}
      expect(course.books).to eq [book]
    end

    it 'parses folders' do
      folder = Models::Folder.new
      Parsers::FolderParser.any_instance.stub(:parse).and_return([folder])
      extractor.extract {}
      expect(course.folders).to eq [folder]
    end

    it 'parses quiz questions' do
      Models::Quizzes::QuestionCategory.any_instance.stub(:resolve_embedded_question_references)
      question_category = Models::Quizzes::QuestionCategory.new
      Parsers::QuestionCategoryParser.any_instance.stub(:parse).and_return([question_category])
      extractor.extract {}
      expect(course.question_categories).to eq [question_category]
      expect(question_category).to have_received(:resolve_embedded_question_references).exactly(1)
    end

    it 'parses quizzes' do
      quiz = Models::Quizzes::Quiz.new
      Parsers::QuizParser.any_instance.stub(:parse).and_return([quiz])
      extractor.extract {}
      expect(course.quizzes).to eq [quiz]
    end

    it 'parses choices' do
      choice = Models::Choice.new
      Parsers::ChoiceParser.any_instance.stub(:parse).and_return([choice])
      extractor.extract {}
      expect(course.choices).to eq [choice]
    end

    it 'parses feedbacks' do
      feedback = Models::Feedback.new
      Parsers::FeedbackParser.any_instance.stub(:parse).and_return([feedback])
      extractor.extract {}
      expect(course.feedbacks).to eq [feedback]
    end

    it 'parses questionnaires' do
      questionnaire = Models::Questionnaire.new
      Parsers::QuestionnaireParser.any_instance.stub(:parse).and_return([questionnaire])
      extractor.extract {}
      expect(course.questionnaires).to eq [questionnaire]
    end

    it 'parses glossaries' do
      glossary = Models::Glossary.new
      Parsers::GlossaryParser.any_instance.stub(:parse).and_return([glossary])
      extractor.extract {}
      expect(course.glossaries).to eq [glossary]
    end

    it 'parses labels' do
      external_url = Models::Label.new
      Parsers::LabelParser.any_instance.stub(:parse).and_return([external_url])
      extractor.extract {}
      expect(course.labels).to eq [external_url]
    end

    it 'parses external_urls' do
      external_url = Models::ExternalUrl.new
      Parsers::ExternalUrlParser.any_instance.stub(:parse).and_return([external_url])
      extractor.extract {}
      expect(course.external_urls).to eq [external_url]
    end

    it 'parses resources' do
      resource = Models::Resource.new
      Parsers::ResourceParser.any_instance.stub(:parse).and_return([resource])
      extractor.extract {}
      expect(course.resources).to eq [resource]
    end

    it 'parses lti links' do
      resource = Models::Lti.new
      Parsers::LtiParser.any_instance.stub(:parse).and_return([resource])
      extractor.extract {}
      expect(course.lti_links).to eq [resource]
    end
  end
end