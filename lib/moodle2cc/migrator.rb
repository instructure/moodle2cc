module Moodle2CC
  class Migrator
    def initialize(source, destination)
      @source = source
      @destination = destination
      raise(Moodle2CC::Error, "'#{@source}' does not exist") unless File.exists?(@source)
      raise(Moodle2CC::Error, "'#{@destination}' is not a directory") unless File.directory?(@destination)
    end

    def migrate
      backup = Moodle2CC::Moodle::Backup.read @source
      converter = Moodle2CC::CC::Converter.new backup, @destination
      converter.convert
    end
  end
end
