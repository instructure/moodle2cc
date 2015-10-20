module Moodle2CC::Moodle2Converter
  class Migrator

    include ConverterHelper

    def initialize(source_file, output_dir)
      self.class.clear_unique_id_set!
      @extractor = Moodle2CC::Moodle2::Extractor.new(source_file)
      @output_dir = output_dir
    end

    def migrate
      @extractor.extract do |moodle_course|
        cc_course = convert_course(moodle_course)
        cc_course.files += convert_files(moodle_course.files)
        cc_course.pages += convert_pages(moodle_course.pages)
        cc_course.pages += convert_wikis(moodle_course.wikis)
        cc_course.discussions += convert_discussions(moodle_course.forums)
        cc_course.assignments += convert_assignments(moodle_course.assignments, moodle_course.grading_scales)

        cc_course.mute_assignments! unless moodle_course.show_grades

        cc_course.assessments += convert_assessments(moodle_course.quizzes, moodle_course.choices,
          moodle_course.feedbacks, moodle_course.questionnaires)
        cc_course.question_banks += convert_question_banks(moodle_course.question_categories)

        cc_course.pages += convert_sections_to_pages(moodle_course.sections)
        cc_course.pages += convert_folders(moodle_course)
        cc_course.pages += convert_books(moodle_course.books)
        cc_course.pages += convert_labels(moodle_course.labels)
        cc_course.pages += convert_glossaries(moodle_course)

        cc_course.pages.each do |canvas_page|
          canvas_page.href = generate_unique_resource_path(Moodle2CC::CanvasCC::Models::Page::WIKI_CONTENT, canvas_page.title)
        end

        cc_course.canvas_modules += convert_sections(moodle_course.sections)

        resolve_duplicate_page_titles!(cc_course)
        convert_html!(cc_course, moodle_course)

        cc_course.resolve_question_references!
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

    def convert_sections(sections)
      section_converter = Moodle2CC::Moodle2Converter::SectionConverter.new
      sections.map { |section| section_converter.convert(section) if !section.empty? }.compact
    end

    def convert_files(files)
      file_converter = Moodle2CC::Moodle2Converter::FileConverter.new
      Array.new(files.uniq { |f| f.content_hash }).map { |file| file_converter.convert(file) }
    end

    def convert_pages(pages)
      page_converter = Moodle2CC::Moodle2Converter::PageConverter.new
      pages.map { |page| page_converter.convert(page) }
    end

    def convert_wikis(wikis)
      wiki_converter = Moodle2CC::Moodle2Converter::WikiConverter.new
      wikis.map { |wiki| wiki_converter.convert(wiki) }.flatten
    end

    def convert_discussions(discussions)
      discussion_converter = Moodle2CC::Moodle2Converter::DiscussionConverter.new
      discussions.map { |discussion| discussion_converter.convert(discussion) }
    end

    def convert_assignments(assignments, grading_scales)
      assignment_converter = Moodle2CC::Moodle2Converter::AssignmentConverter.new
      assignments.map { |assignment| assignment_converter.convert(assignment, grading_scales) }
    end

    def convert_sections_to_pages(sections)
      converter = Moodle2CC::Moodle2Converter::SectionConverter.new
      sections.map{|s| converter.convert_to_summary_page(s) if s.summary?}.compact
    end

    def convert_folders(moodle_course)
      folder_converter = Moodle2CC::Moodle2Converter::FolderConverter.new(moodle_course)
      moodle_course.folders.map { |folder| folder_converter.convert(folder) }
    end

    def convert_books(books)
      book_converter = Moodle2CC::Moodle2Converter::BookConverter.new
      books.map { |book| book_converter.convert_to_pages(book) }.flatten
    end

    def convert_labels(labels)
      label_converter = Moodle2CC::Moodle2Converter::LabelConverter.new
      labels.map { |label| label_converter.convert_to_pages(label) }.flatten
    end

    def convert_glossaries(moodle_course)
      glossary_converter = Moodle2CC::Moodle2Converter::GlossaryConverter.new(moodle_course)
      moodle_course.glossaries.map { |glossary| glossary_converter.convert(glossary) }
    end

    # convert quizzes to assessments
    def convert_assessments(quizzes, choices, feedbacks, questionnaires)
      assessment_converter = Moodle2CC::Moodle2Converter::AssessmentConverter.new
      assessments = []
      assessments += quizzes.map { |quiz| assessment_converter.convert_quiz(quiz) }
      assessments += choices.map { |choice| assessment_converter.convert_choice(choice) }
      assessments += feedbacks.map { |feedback| assessment_converter.convert_feedback(feedback) }
      assessments += questionnaires.map { |questionnaire| assessment_converter.convert_questionnaire(questionnaire) }
      assessments
    end

    # convert question categories to question banks
    def convert_question_banks(question_categories)
      bank_converter = Moodle2CC::Moodle2Converter::QuestionBankConverter.new
      question_categories.map { |category| bank_converter.convert(category) }
    end

    def convert_html!(cc_course, moodle_course)
      html_converter = HtmlConverter.new(cc_course.files, moodle_course)
      cc_course.pages.each {|page| page.body = html_converter.convert(page.body)}
      cc_course.discussions.each {|discussion| discussion.text = html_converter.convert(discussion.text)}
      cc_course.assignments.each {|assignment| assignment.body = html_converter.convert(assignment.body)}

      cc_course.assessments.each do |assessment|
        assessment.description = html_converter.convert(assessment.description)

        next unless assessment.items
        assessment.items.each do |item|
          if item.is_a?(Moodle2CC::CanvasCC::Models::QuestionGroup)
            item.questions.each do |question|
              convert_question_html!(question, html_converter)
            end
          elsif item.is_a?(Moodle2CC::CanvasCC::Models::Question)
            convert_question_html!(item, html_converter)
          end
        end
      end

      cc_course.question_banks.each do |question_bank|
        question_bank.questions.each do |question|
          convert_question_html!(question, html_converter)
        end
      end
    end

    def convert_question_html!(question, html_converter)
      question.material = html_converter.convert(question.material)
      question.general_feedback = html_converter.convert(question.general_feedback) if question.general_feedback

      question.answers.each do |answer|
        answer.answer_text = html_converter.convert(answer.answer_text)
        answer.feedback = html_converter.convert(answer.feedback) if answer.feedback
      end

      question.post_process! if question.is_a?(Moodle2CC::CanvasCC::Models::CalculatedQuestion)
    end

    def resolve_duplicate_page_titles!(cc_course)
      page_titles = cc_course.pages.map(&:title)
      duplicate_page_map = cc_course.pages.group_by(&:title).select{|k, v| v.count > 1}
      duplicate_page_map.each do |title, dup_pages|
        dup_pages.sort_by!{|page| find_module_index_for_page(cc_course, page)}

        dup_pages.each_with_index do |page, index|
          next if index == 0
          num = index + 1
          while (title = "#{page.title}-#{num}") && page_titles.include?(title)
            num += 1
          end
          page.title = title
        end
      end
    end

    def find_module_index_for_page(cc_course, canvas_page)
      cc_course.canvas_modules.each_with_index do |canvas_module, module_index|
        canvas_module.module_items.each_with_index do |module_item, item_index|
          if module_item.identifierref.to_s == canvas_page.identifier.to_s
            return [module_index, item_index]
          end
        end
      end
      [Float::INFINITY]
    end

    def self.clear_unique_id_set!
      @unique_id_set = Set.new
    end

    def self.unique_id_set
      @unique_id_set ||= Set.new
    end
  end
end