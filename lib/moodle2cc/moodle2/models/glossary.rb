module Moodle2CC::Moodle2::Models
  class Glossary
    attr_accessor :id, :name, :intro, :intro_format, :allow_duplicated_entries, :display_format, :main_glossary, :show_special,
                  :show_alphabet, :show_all, :allow_comments, :allow_printview, :use_dynalink, :default_approval, :global_glossary,
                  :ent_by_page, :edit_always, :rss_type, :rss_articles, :assessed, :assess_time_start, :assess_time_finish, :scale,
                  :completion_entries, :module_id, :entries

    def initialize
      @entries = []
    end

  end
end