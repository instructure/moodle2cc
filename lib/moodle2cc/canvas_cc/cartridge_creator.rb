class Moodle2CC::CanvasCC::CartridgeCreator

  IMS_MANIFEST = 'imsmanifest.xml'

  def initialize(course)
    @course = course
  end

  def create(out_dir)
    out_file = File.join(out_dir, filename)
    Dir.mktmpdir do |dir|
      tmp_file = File.join(dir, filename)
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
    File.open(File.join(work_dir, 'imsmanifest.xml'), 'w'){|f| f.write(xml)}
  end

end