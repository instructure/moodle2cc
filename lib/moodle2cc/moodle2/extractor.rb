require 'zip'

module Moodle2CC::Moodle2
  class Extractor

    MOODLE_BACKUP_XML = 'moodle_backup.xml'

    def initialize(backup_path)
      @backup_path = backup_path
    end

    def extract
      if File.directory?(@backup_path) # it's already extracted
        course = extract_course(@backup_path)
        yield course
      else
        Dir.mktmpdir do |work_dir|
          extract_zip(work_dir)
          course = extract_course(work_dir)
          yield course
        end
      end
    end

    private

    def extract_course(work_dir)
      course = Moodle2CC::Moodle2::Parsers::CourseParser.new(work_dir).parse
      parse_sections(work_dir, course)
      parse_files(work_dir, course)
      parse_pages(work_dir, course)
      parse_forums(work_dir, course)
      parse_assignments(work_dir, course)
      parse_books(work_dir, course)
      parse_folders(work_dir, course)
      parse_wikis(work_dir, course)
      parse_question_categories(work_dir, course)

      parse_quizzes(work_dir, course)
      parse_choices(work_dir, course)
      parse_feedbacks(work_dir, course)
      parse_questionnaires(work_dir, course)

      parse_glossaries(work_dir, course)
      parse_labels(work_dir, course)
      parse_external_urls(work_dir, course)
      parse_resources(work_dir, course)
      parse_lti_links(work_dir, course)
      collect_files_for_resources(course)
      collect_activities_for_sections(course.sections, course.activities)
      course
    end

    def extract_zip(work_dir)
      if File.directory?(@backup_path)
        Dir["#{@backup_path}/**/*"].each do |f_path|
          f_path=File.join(work_dir, f.name)
        end
      else
        Zip::File.open(@backup_path) do |zip_file|
          zip_file.each do |f|
            f_path=File.join(work_dir, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          end
        end
      end
    end

    def parse_sections(work_dir, course)
      if sections = Moodle2CC::Moodle2::Parsers::SectionParser.new(work_dir).parse
        course.sections += sections
      end
    end

    def parse_files(work_dir, course)
      if result = Moodle2CC::Moodle2::Parsers::FileParser.new(work_dir).parse
        files, missing_files = result
        course.files += files
        course.missing_files += missing_files
      end
    end

    def parse_pages(work_dir, course)
      if pages = Moodle2CC::Moodle2::Parsers::PageParser.new(work_dir).parse
        course.pages += pages
      end
    end

    def parse_wikis(work_dir, course)
      if wikis = Moodle2CC::Moodle2::Parsers::WikiParser.new(work_dir).parse
        course.wikis += wikis
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

    def parse_choices(work_dir, course)
      if choices = Moodle2CC::Moodle2::Parsers::ChoiceParser.new(work_dir).parse
        course.choices += choices
      end
    end

    def parse_feedbacks(work_dir, course)
      if feedbacks = Moodle2CC::Moodle2::Parsers::FeedbackParser.new(work_dir).parse
        course.feedbacks += feedbacks
      end
    end

    def parse_questionnaires(work_dir, course)
      if questionnaires = Moodle2CC::Moodle2::Parsers::QuestionnaireParser.new(work_dir).parse
        course.questionnaires += questionnaires
      end
    end

    def parse_glossaries(work_dir, course)
      if glossaries = Moodle2CC::Moodle2::Parsers::GlossaryParser.new(work_dir).parse
        course.glossaries += glossaries
      end
    end

    def parse_labels(work_dir, course)
      if labels = Parsers::LabelParser.new(work_dir).parse
        course.labels += labels
      end
    end

    def parse_external_urls(work_dir, course)
      if external_urls = Parsers::ExternalUrlParser.new(work_dir).parse
        course.external_urls += external_urls
      end
    end

    def parse_resources(work_dir, course)
      if resources = Parsers::ResourceParser.new(work_dir).parse
        course.resources += resources
      end
    end

    def parse_lti_links(work_dir, course)
      if lti_links = Parsers::LtiParser.new(work_dir).parse
        course.lti_links = lti_links
      end
    end

    def collect_files_for_resources(course)
      files_hash = {}
      course.files.each{ |file| files_hash[file.id] = file }

      translated_resources = []
      course.resources.each do |resource|
        file_id = resource.file_ids.find{|id| files_hash.key?(id)}
        resource.file = files_hash[file_id]
        if resource.file.nil? && translate_missing_file_reference(resource, course)
          translated_resources << resource
        end
      end

      translated_resources.each do |resource|
        course.resources.delete(resource)
      end
    end

    def translate_missing_file_reference(resource, course)
      # turn missing external files to external urls
      if missing_file = course.missing_files.detect{|f| resource.file_ids.include?(f.id)}
        if missing_file.reference =~ /\"url\"[^\"]*\"([^\"]*)\"/
          url = $1.to_s
          if url.start_with?("http")
            ext_url = Moodle2CC::Moodle2::Models::ExternalUrl.new
            ext_url.id = resource.id
            ext_url.module_id = resource.module_id
            ext_url.name = resource.name
            ext_url.external_url = url
            course.external_urls << ext_url
            return true
          end
        end
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