class Moodle2CC::Moodle2Converter::Migrator

  def initialize(source_file, output_dir)
    @extractor = Moodle2CC::Moodle2::Extractor.new(source_file)
    @output_dir = output_dir
  end

  def migrate
    moodle_course = @extractor.extract
    cc_course = Moodle2CC::Moodle2Converter::CourseConverter.new.convert(moodle_course)
    @path = Moodle2CC::CanvasCC::CartridgeCreator.new(cc_course).create(@output_dir)
  end

  def imscc_path
    @path
  end

end