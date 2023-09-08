require 'zip'

module Moodle2CC
  class Migrator

    attr_accessor :last_error

    MOODLE_1_9 = '1.9'
    MOODLE_2 = '2'

    def initialize(source, destination, options={})
      @source = source
      @destination = destination
      @format = options['format'] || 'cc'
      Moodle2CC::Logger.logger = options['logger'] || ::Logger.new(STDOUT)
      raise(Moodle2CC::Error, "'#{@source}' does not exist") unless File.exist?(@source)
      raise(Moodle2CC::Error, "'#{@destination}' is not a directory") unless File.directory?(@destination)
      raise(Moodle2CC::Error, "'#{@format}' is not a valid format. Please use 'cc' or 'canvas'.") unless ['cc', 'canvas'].include?(@format)
      @converter_class = @format == 'cc' ? Moodle2CC::CC::Converter : Moodle2CC::Canvas::Converter
    end

    def migrate
      @last_error = nil
      case moodle_version
        when MOODLE_1_9
          migrate_moodle_1_9
        when MOODLE_2
          migrate_moodle_2
      end
    rescue StandardError => error
      @last_error = error
      Moodle2CC::Logger.add_warning 'error migrating content', error
    end

    def imscc_path
      @converter.imscc_path
    end

    def migrate_moodle_1_9
      backup = Moodle2CC::Moodle::Backup.read @source
      @converter = @converter_class.new backup, @destination
      @converter.convert
    end

    def migrate_moodle_2
      @converter = Moodle2CC::Moodle2Converter::Migrator.new(@source, @destination)
      @converter.migrate
    end

    private

    def moodle_version
      if File.directory?(@source)
        if File.exist?(File.join(@source, 'moodle_backup.xml'))
          MOODLE_2
        elsif File.exist?(File.join(@source, 'moodle.xml'))
          MOODLE_1_9
        end
      else
        Zip::File.open(@source) do |zipfile|
          if zipfile.find_entry('moodle_backup.xml')
            MOODLE_2
          elsif zipfile.find_entry('moodle.xml')
            MOODLE_1_9
          end
        end
      end
    end

  end
end