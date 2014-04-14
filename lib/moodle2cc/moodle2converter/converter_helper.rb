module Moodle2CC
  module Moodle2Converter::ConverterHelper
    INTRO_SUFFIX = '_book_intro'
    CHAPTER_SUFFIX = '_chapter'
    FOLDER_SUFFIX = '_folder'
    PAGE_SUFFIX = '_page'
    ASSESSMENT_SUFFIX = '_assessment'
    CHOICE_ASSESSMENT_SUFFIX = '_choice_assessment'
    QUESTIONNAIRE_ASSESSMENT_SUFFIX = '_questionnaire_assessment'
    ASSIGNMENT_SUFFIX = '_assignment'
    COURSE_SUFFIX = '_course'
    DISCUSSION_SUFFIX = '_discussion'
    FILE_SUFFIX = '_file'
    QUESTION_BANK_SUFFIX = '_question_bank'
    MODULE_SUFFIX = '_module'
    GLOSSARY_SUFFIX = '_glossary'
    SUMMARY_PAGE_SUFFIX = '_summary_page'
    EXTERNAL_URL_SUFFIX = '_external_url'

    ACTIVITY_LOOKUP = {
      Moodle2::Models::Page => {suffix: PAGE_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE},
      Moodle2::Models::Assignment => {suffix: ASSIGNMENT_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_ASSIGNMENT},
      Moodle2::Models::Folder => {suffix: FOLDER_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE},
      Moodle2::Models::Forum => {suffix: DISCUSSION_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_DISCUSSION_TOPIC},
      Moodle2::Models::BookChapter => {suffix: CHAPTER_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE},
      Moodle2::Models::Quizzes::Quiz => {suffix: ASSESSMENT_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_QUIZ},
      Moodle2::Models::Choice => {suffix: CHOICE_ASSESSMENT_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_QUIZ},
      Moodle2::Models::Questionnaire => {suffix: QUESTIONNAIRE_ASSESSMENT_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_QUIZ},
      Moodle2::Models::Section => {suffix: SUMMARY_PAGE_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE},
      Moodle2::Models::Label => {suffix: nil, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_CONTEXT_MODULE_SUB_HEADER},
      Moodle2::Models::Glossary => {suffix: GLOSSARY_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_WIKI_PAGE},
      Moodle2::Models::ExternalUrl => {suffix: EXTERNAL_URL_SUFFIX, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_EXTERNAL_URL},
      Moodle2::Models::Resource => {suffix: nil, content_type: CanvasCC::Models::ModuleItem::CONTENT_TYPE_ATTACHMENT}
    }

    def generate_unique_resource_path(base_path, readable_name, file_extension = 'html')
      file_name_suffix = readable_name ? CGI::escape(readable_name.downcase.strip.gsub(/\s/, '-')) : ''
      ext = file_extension ? ".#{file_extension}" : ''
      File.join(base_path, generate_unique_identifier(), "#{file_name_suffix}#{ext}")
    end

    def generate_unique_identifier
      "m2#{SecureRandom.uuid.gsub('-', '')}"
    end

    def generate_unique_identifier_for_activity(activity)
      if lookup = ACTIVITY_LOOKUP[activity.class]
        generate_unique_identifier_for(activity.id, lookup[:suffix])
      else
        raise "Unknown activity type: #{activity.class}"
      end
    end

    def generate_unique_identifier_for(id, suffix = nil)
      "m2#{Digest::MD5.hexdigest(id.to_s)}#{suffix}"
    end

    def activity_content_type(activity)
      if lookup = ACTIVITY_LOOKUP[activity.class]
        lookup[:content_type]
      else
        raise "Unknown activity type: #{activity.class}"
      end
    end

    def workflow_state(moodle_visibility)
      moodle_visibility ? CanvasCC::Models::WorkflowState::ACTIVE : CanvasCC::Models::WorkflowState::UNPUBLISHED
    end


  end
end
