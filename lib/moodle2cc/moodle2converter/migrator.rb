module Moodle2CC::Moodle2Converter
  class Migrator

    def initialize(source_file, output_dir)
      @extractor = Moodle2CC::Moodle2::Extractor.new(source_file)
      @output_dir = output_dir
    end

    def migrate
      @extractor.extract do |moodle_course|
        cc_course = convert_course(moodle_course)
        cc_course.files += convert_files(moodle_course.files)
        cc_course.pages += convert_pages(moodle_course.pages)
        cc_course.discussions += convert_discussions(moodle_course.forums)
        cc_course.assignments += convert_assignments(moodle_course.assignments)

        cc_course.assessments += convert_assessments(moodle_course.quizzes)
        cc_course.question_banks += convert_question_banks(moodle_course.question_categories)

        cc_course.pages += convert_folders(moodle_course)
        cc_course.pages += convert_books(moodle_course)
        cc_course.pages += convert_glossaries(moodle_course)

        first_section = moodle_course.sections.shift
        cc_course.pages << convert_homepage(first_section) if first_section

        cc_course.canvas_modules += convert_sections(moodle_course.sections)

        convert_html!(cc_course, moodle_course)

        @path = Moodle2CC::CanvasCC::CartridgeCreator.new(cc_course).create(@output_dir)
      end
      @path
    end

    def imscc_path
      @path
    end

    private

    def convert_course(moodle_course)
      Moodle2CC::Moodle2Converter::CourseConverter.new.convert(moodle_course)
    end

    def convert_homepage(moodle_section)
      Moodle2CC::Moodle2Converter::HomepageConverter.new.convert(moodle_section)
    end

    def convert_sections(sections)
      section_converter = Moodle2CC::Moodle2Converter::SectionConverter.new
      sections.map { |section| section_converter.convert(section) }
    end

    def convert_files(files)
      file_converter = Moodle2CC::Moodle2Converter::FileConverter.new
      Array.new(files.uniq { |f| f.content_hash }).map { |file| file_converter.convert(file) }
    end

    def convert_pages(pages)
      page_converter = Moodle2CC::Moodle2Converter::PageConverter.new
      pages.map { |page| page_converter.convert(page) }
    end

    def convert_discussions(discussions)
      discussion_converter = Moodle2CC::Moodle2Converter::DiscussionConverter.new
      discussions.map { |discussion| discussion_converter.convert(discussion) }
    end

    def convert_assignments(assignments)
      assignment_converter = Moodle2CC::Moodle2Converter::AssignmentConverter.new
      assignments.map { |assignment| assignment_converter.convert(assignment) }
    end

    def convert_folders(moodle_course)
      folder_converter = Moodle2CC::Moodle2Converter::FolderConverter.new(moodle_course)
      moodle_course.folders.map { |folder| folder_converter.convert(folder) }
    end

    def convert_books(moodle_course)
      book_converter = Moodle2CC::Moodle2Converter::BookConverter.new
      moodle_course.books.map { |book| book_converter.convert_to_pages(book) }.flatten
    end

    def convert_glossaries(moodle_course)
      glossary_converter = Moodle2CC::Moodle2Converter::GlossaryConverter.new(moodle_course)
      moodle_course.glossaries.map { |glossary| glossary_converter.convert(glossary) }
    end

    # convert quizzes to assessments
    def convert_assessments(quizzes)
      assessment_converter = Moodle2CC::Moodle2Converter::AssessmentConverter.new
      quizzes.map { |quiz| assessment_converter.convert(quiz) }
    end

    # convert question categories to question banks
    def convert_question_banks(question_categories)
      bank_converter = Moodle2CC::Moodle2Converter::QuestionBankConverter.new
      question_categories.map { |category| bank_converter.convert(category) }
    end

    def convert_html!(cc_course, moodle_files)
      html_converter = HtmlConverter.new(cc_course, moodle_files)
      cc_course.pages.each {|page| page.body = html_converter.convert(page.body)}
      cc_course.discussions.each {|discussion| discussion.text = html_converter.convert(discussion.text)}
      cc_course.assignments.each {|assignment| assignment.body = html_converter.convert(assignment.body)}
      cc_course.assessments.each {|assessment| assessment.description = html_converter.convert(assessment.description)}
    end

  end
end