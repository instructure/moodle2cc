module Moodle2CC::Moodle2::Parsers
  class BookParser
    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      Moodle2CC::Moodle2::Models::Book.new
    end
  end
end