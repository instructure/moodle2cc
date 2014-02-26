class Moodle2CC::Moodle2Converter::Migrator

  def initialize(source_file, output_dir)
    @extractor = Moodle2CC::Moodle2::Extractor.new(source_file)
    @output_dir = output_dir
  end

  def migrate
    @extractor.extract do |moodle_course|
      cc_course = convert_course(moodle_course)
      cc_course.canvas_modules += convert_sections(moodle_course.sections)
      cc_course.files += convert_files(moodle_course.files)
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
    sections.map { |section| section_converter.convert(section) }
  end

  def convert_files(files)
    file_converter = Moodle2CC::Moodle2Converter::FileConverter.new
    files.map { |file| file_converter.convert(file) }
  end

end