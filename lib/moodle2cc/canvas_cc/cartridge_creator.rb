class Moodle2CC::CanvasCC::CartridgeCreator

  IMS_MANIFEST_FILE = 'imsmanifest.xml'
  COURSE_SETTINGS_FILE = 'course_settings.xml'
  CANVAS_EXPORT_FILE = 'canvas_export.txt'
  SETTINGS_POSTFIX = '_settings'
  COURSE_SETTINGS_DIR = 'course_settings'
  TYPE_LAR = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'
  MODULE_META_FILE = 'module_meta.xml'

  def initialize(course)
    @course = course
  end

  def create(out_dir)
    out_file = File.join(out_dir, filename)
    Dir.mktmpdir do |dir|
      tmp_file = File.join(dir, filename)
      write_course_settings(dir)
      write_manifiest_xml(dir)
      Zip::File.open(tmp_file, Zip::File::CREATE) do |zipfile|
        Dir["#{dir}/**/*"].each do |file|
          zipfile.add(file.sub(dir + '/', ''), file)
        end
      end
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

  def write_manifiest_xml(work_dir)
    xml = Moodle2CC::CanvasCC::ImsManifestGenerator.new(@course).generate
    File.open(File.join(work_dir, IMS_MANIFEST_FILE), 'w'){|f| f.write(xml)}
  end

  def write_course_settings(work_dir)
    setting_identifier = "#{@course.identifier}#{SETTINGS_POSTFIX}"
    resource = Moodle2CC::CanvasCC::Model::Resource.new
    resource.type = TYPE_LAR
    resource.identifier = setting_identifier
    resource.href = File.join(COURSE_SETTINGS_DIR, CANVAS_EXPORT_FILE)
    xml = Moodle2CC::CanvasCC::CourseSettingWriter.new(@course, setting_identifier).write
    Dir.mkdir(File.join(work_dir, COURSE_SETTINGS_DIR))
    File.open(File.join(work_dir, COURSE_SETTINGS_DIR, COURSE_SETTINGS_FILE), 'w' ) {|f| f.write(xml)}
    File.open(File.join(work_dir, COURSE_SETTINGS_DIR, CANVAS_EXPORT_FILE), 'w' )do |f|
      f.write("Q: What did the panda say when he was forced out of his natural habitat?\nA: This is un-BEAR-able")
    end
    if @course.canvas_modules.count > 0
      module_meta_xml = Moodle2CC::CanvasCC::ModuleMetaWriter.new(@course.canvas_modules).write
      module_meta_path = File.join(COURSE_SETTINGS_DIR, MODULE_META_FILE)
      File.open(File.join(work_dir, module_meta_path), 'w') {|f| f.write(module_meta_xml)}
      resource.files << module_meta_path
    end
    resource.files << File.join(COURSE_SETTINGS_DIR, COURSE_SETTINGS_FILE)
    @course.resources << resource
  end

end