require 'zip/zipfilesystem'

module TestHelper
  def create_moodle_backup_zip(backup_name='moodle_backup')
    moodle_backup_path = File.expand_path("../../../test/tmp/#{backup_name}.zip", __FILE__)
    Zip::ZipFile.open(moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add("moodle.xml", File.expand_path("../../../test/fixtures/#{backup_name}/moodle.xml", __FILE__))
      zipfile.mkdir("course_files")
      zipfile.mkdir("course_files/folder")
      zipfile.add("course_files/test.txt", File.expand_path("../../../test/fixtures/#{backup_name}/course_files/test.txt", __FILE__))
      zipfile.add("course_files/folder/test.txt", File.expand_path("../../../test/fixtures/#{backup_name}/course_files/folder/test.txt", __FILE__))
    end
    moodle_backup_path
  end

  def convert_moodle_backup(format='cc', backup_name='moodle_backup')
    raise "must be 'cc' or 'canvas'" unless ['cc', 'canvas'].include?(format)
    converter_class = format == 'cc' ? Moodle2CC::CC::Converter : Moodle2CC::Canvas::Converter
    @backup_path = create_moodle_backup_zip(backup_name)
    @backup = Moodle2CC::Moodle::Backup.read @backup_path
    @export_dir = File.expand_path("../../../test/tmp", __FILE__)
    @converter = converter_class.new @backup, @export_dir
    @converter.convert
  end

  def get_imsmanifest_xml
    Zip::ZipFile.open(@converter.imscc_path) do |zipfile|
      xml = Nokogiri::XML(zipfile.read("imsmanifest.xml"))
    end
  end

  def get_imscc_file(file)
    Zip::ZipFile.open(@converter.imscc_path) do |zipfile|
      zipfile.read(file)
    end
  end

  def clean_tmp_folder
    Dir[File.expand_path("../../../test/tmp/*", __FILE__)].each do |file|
      FileUtils.rm_r file
    end
  end
end
