module Moodle2CC
  class Migrator
    def initialize(source, destination, options={})
      @source = source
      @destination = destination
      @format = options['format'] || 'cc'
      Moodle2CC::Logger.logger = options['logger'] || ::Logger.new(STDOUT)
      raise(Moodle2CC::Error, "'#{@source}' does not exist") unless File.exists?(@source)
      raise(Moodle2CC::Error, "'#{@destination}' is not a directory") unless File.directory?(@destination)
      raise(Moodle2CC::Error, "'#{@format}' is not a valid format. Please use 'cc' or 'canvas'.") unless ['cc', 'canvas'].include?(@format)
      @converter_class = @format == 'cc' ? Moodle2CC::CC::Converter : Moodle2CC::Canvas::Converter
    end

    def migrate
      backup = Moodle2CC::Moodle::Backup.read @source
      @converter = @converter_class.new backup, @destination
      @converter.convert
    rescue StandardError => error
      Moodle2CC::Logger.add_warning 'error migrating content', error
    end

    def imscc_path
      @converter.imscc_path
    end
  end
end
