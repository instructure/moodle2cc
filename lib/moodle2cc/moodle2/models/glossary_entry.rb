module Moodle2CC::Moodle2::Models
  class GlossaryEntry
    attr_accessor :id, :user_id, :concept, :definition, :definition_format, :definition_trust, :attachment,
                  :teacher_entry, :source_glossary_id, :use_dynalink, :case_sensitive, :full_match, :approved,
                  :aliases, :ratings

    def initialize
      @aliases = []
      @ratings = []
    end

  end
end