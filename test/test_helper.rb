require 'zip/zipfilesystem'

module TestHelper
  def create_moodle_backup_zip
    moodle_backup_path = File.expand_path("../tmp/moodle_backup.zip", __FILE__)
    Zip::ZipFile.open(moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.file.open("moodle.xml", "w") { |f| f.write File.read(File.expand_path("../fixtures/moodle.xml", __FILE__)) }
    end
    moodle_backup_path
  end
end
