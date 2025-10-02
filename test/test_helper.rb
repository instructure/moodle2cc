require 'minitest/autorun'
require 'zip'
require 'moodle2cc'

module TestHelper

  def create_moodle_backup_zip(backup_name='moodle_backup')
    moodle_backup_path = File.expand_path("../../test/tmp/#{backup_name}.zip", __FILE__)
    Zip::File.open(moodle_backup_path, create: true) do |zipfile|
      zipfile.remove("moodle.xml") if zipfile.find_entry("moodle.xml")
      zipfile.add("moodle.xml", fixture_path("#{backup_name}/moodle.xml"))
      zipfile.mkdir("course_files")
      zipfile.mkdir("course_files/folder")
      zipfile.add("course_files/test.txt", fixture_path("#{backup_name}/course_files/test.txt"))
      zipfile.add("course_files/folder/test.txt", fixture_path("#{backup_name}/course_files/folder/test.txt"))
    end
    moodle_backup_path
  end

  def convert_moodle_backup(format='cc', backup_name='moodle_backup')
    raise "must be 'cc' or 'canvas'" unless ['cc', 'canvas'].include?(format)
    converter_class = format == 'cc' ? Moodle2CC::CC::Converter : Moodle2CC::Canvas::Converter
    @backup_path = create_moodle_backup_zip(backup_name)
    @backup = Moodle2CC::Moodle::Backup.read @backup_path
    @export_dir = File.expand_path("../../test/tmp", __FILE__)
    @converter = converter_class.new @backup, @export_dir
    @converter.convert
  end

  def get_imsmanifest_xml
    Zip::File.open(@converter.imscc_path) do |zipfile|
      xml = Nokogiri::XML(zipfile.read("imsmanifest.xml"))
    end
  end

  def get_imscc_file(file)
    Zip::File.open(@converter.imscc_path) do |zipfile|
      zipfile.read(file)
    end
  end

  def clean_tmp_folder
    Dir[File.expand_path("../../test/tmp/*", __FILE__)].each do |file|
      FileUtils.rm_r file
    end
  end

  def assert_accessors(object, *accessor)
    accessor.each do |a|
      orig_val = object.send(a.to_sym)
      object.send "#{a}=".to_sym, 'foo'
      assert_equal object.send(a.to_sym), 'foo'
      object.send "#{a}=".to_sym, orig_val
    end
  end

  def fixture_path(path)
    File.join(File.expand_path("../../test/fixtures", __FILE__), path)
  end

  def expect(obj, method_name)
    verify_mock = MiniTest::Mock.new
    verify_mock.expect(:test_method, nil)
    verify_method = lambda { verify_mock.test_method() }
    obj.stub(method_name.to_sym, verify_method) do
      yield
    end
    verify_mock.verify
  end
  
end
