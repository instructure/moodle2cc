class Moodle2CC::CanvasCC::CartridgeCreator

  IMS_MANIFEST_FILE = 'imsmanifest.xml'
  COURSE_SETTINGS_FILE = 'course_settings.xml'
  SETTINGS_POSTFIX = '_settings'
  COURSE_SETTINGS_DIR = 'course_settings'
  TYPE_LAR = 'associatedcontent/imscc_xmlv1p1/learning-application-resource'

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
    xml = Moodle2CC::CanvasCC::CourseSettingWriter.new(@course, setting_identifier).write
    Dir.mkdir(File.join(work_dir, COURSE_SETTINGS_DIR))
    File.open(File.join(work_dir, COURSE_SETTINGS_DIR, COURSE_SETTINGS_FILE), 'w'){|f| f.write(xml)}
    resource.files << File.join(COURSE_SETTINGS_DIR, COURSE_SETTINGS_FILE)
    @course.resources << resource
  end

end