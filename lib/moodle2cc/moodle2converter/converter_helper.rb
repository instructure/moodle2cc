module Moodle2CC
  module Moodle2Converter::ConverterHelper
    INTRO_SUFFIX    = '_book_intro'
    CHAPTER_SUFFIX  = '_chapter'
    FOLDER_SUFFIX   = '_folder'
    PAGE_SUFFIX     = '_page'

    ID_SUFFIXES = {
        Moodle2CC::Moodle2::Models::Page => PAGE_SUFFIX
    }

    def update_links(content)
      return unless content
      content.gsub('@@PLUGINFILE@@', '%24IMS_CC_FILEBASE%24')
    end

    def generate_unique_resource_path(base_path, readable_name = nil, file_extension = nil)
      file_name_suffix = readable_name ? '-' + readable_name.downcase.gsub(/\s/, '-') : ''
      ext = file_extension ? ".#{file_extension}" : ''
      File.join(base_path, "#{generate_unique_identifier}#{file_name_suffix}#{ext}")
    end

    def generate_unique_identifier
      "m2#{SecureRandom.uuid.gsub('-', '')}"
    end

    def generate_unique_identifier_for_activity(activity)
      generate_unique_identifier_for(activity.id, ID_SUFFIXES[activity.class])
    end

    def generate_unique_identifier_for(id, suffix = nil)
      "m2#{Digest::MD5.hexdigest(id.to_s)}#{suffix}"
    end
  end
end
