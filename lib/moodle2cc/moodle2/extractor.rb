require 'zip'

module Moodle2CC::Moodle2
  class Extractor

    MOODLE_BACKUP_XML = 'moodle_backup.xml'

    def initialize(zip_path)
      @zip_path = zip_path
    end

    def extract
      Dir.mktmpdir do |work_dir|
        extract_zip(work_dir)
        course = Moodle2CC::Moodle2::Parsers::CourseParser.new(work_dir).parse
        parse_sections(work_dir, course)
        parse_files(work_dir, course)
        parse_pages(work_dir, course)
        parse_forums(work_dir, course)
        parse_assignments(work_dir, course)
        parse_books(work_dir, course)
        parse_folders(work_dir, course)
        parse_question_categories(work_dir, course)
        parse_quizzes(work_dir, course)
        parse_glossaries(work_dir, course)
        collect_activities_for_sections(course.sections, course.activities)
        yield course
      end
    end

    private

    def extract_zip(work_dir)
      Zip::File.open(@zip_path) do |zip_file|
        zip_file.each do |f|
          f_path=File.join(work_dir, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        end
      end
    end

    def parse_sections(work_dir, course)
      if sections = Moodle2CC::Moodle2::Parsers::SectionParser.new(work_dir).parse
        course.sections += sections
      end
    end

    def parse_files(work_dir, course)
      if files = Moodle2CC::Moodle2::Parsers::FileParser.new(work_dir).parse
        course.files += files
      end
    end

    def parse_pages(work_dir, course)
      if pages = Moodle2CC::Moodle2::Parsers::PageParser.new(work_dir).parse
        course.pages += pages
      end
    end

    def parse_forums(work_dir, course)
      if forums = Moodle2CC::Moodle2::Parsers::ForumParser.new(work_dir).parse
        course.forums += forums
      end
    end

    def parse_assignments(work_dir, course)
      if assignments = Moodle2CC::Moodle2::Parsers::AssignmentParser.new(work_dir).parse
        course.assignments += assignments
      end
    end

    def parse_books(work_dir, course)
      if books = Moodle2CC::Moodle2::Parsers::BookParser.new(work_dir).parse
        course.books += books
      end
    end

    def parse_folders(work_dir, course)
      if folders = Moodle2CC::Moodle2::Parsers::FolderParser.new(work_dir).parse
        course.folders += folders
      end
    end

    def parse_question_categories(work_dir, course)
      if question_categories = Moodle2CC::Moodle2::Parsers::QuestionCategoryParser.new(work_dir).parse
        course.question_categories += question_categories
      end
      course.question_categories.each{|qc| qc.resolve_embedded_question_references(question_categories)}
    end

    def parse_quizzes(work_dir, course)
      if quizzes = Moodle2CC::Moodle2::Parsers::QuizParser.new(work_dir).parse
        course.quizzes += quizzes
      end
    end

    def parse_glossaries(work_dir, course)
      if glossaries = Moodle2CC::Moodle2::Parsers::GlossaryParser.new(work_dir).parse
        course.glossaries += glossaries
      end
    end

    def collect_activities_for_sections(sections, activities)
      activities_hash = {}
      activities.each { |activity| activities_hash[activity.module_id.to_s] = activity }
      sections.each do |section|
        section.activities = section.sequence.map { |module_id| activities_hash[module_id.to_s] }.compact
      end
    end

  end
end