class Moodle2CC::CanvasCC::CartridgeCreator

  COURSE_SETTINGS_DIR = 'course_settings'

  def initialize(course)
    @course = course
  end

  def create(out_dir)
    out_file = File.join(out_dir, filename)
    Dir.mktmpdir do |dir|
      write_cartridge(dir)

      tmp_file = File.join(dir, filename)
      zip_dir(tmp_file, dir)
      FileUtils.mv(tmp_file, out_file)
    end
    out_file
  end

  def filename
    title = @course.title.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr("- ", "_").downcase
    "#{title}.imscc"
  end

  private

  def write_cartridge(dir)
    Dir.mkdir(File.join(dir, COURSE_SETTINGS_DIR))
    Moodle2CC::CanvasCC::CanvasExportWriter.new(dir).write
    Moodle2CC::CanvasCC::CourseSettingWriter.new(dir, @course).write
    Moodle2CC::CanvasCC::ModuleMetaWriter.new(dir, *@course.canvas_modules).write
    Moodle2CC::CanvasCC::ImsManifestGenerator.new(dir, @course).write
    Moodle2CC::CanvasCC::FileMetaWriter.new(dir, *@course.files).write
    Moodle2CC::CanvasCC::PageWriter.new(dir, *@course.pages).write
    Moodle2CC::CanvasCC::DiscussionWriter.new(dir, *@course.discussions).write
  end

  def zip_dir(out_file, dir)
    Zip::File.open(out_file, Zip::File::CREATE) do |zipfile|
      Dir["#{dir}/**/*"].each do |file|
        zipfile.add(file.sub(dir + '/', ''), file)
      end
    end
  end

end