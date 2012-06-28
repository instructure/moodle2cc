require 'zip/zipfilesystem'

module TestHelper
  def create_moodle_backup_zip
    moodle_backup_path = File.expand_path("../tmp/moodle_backup.zip", __FILE__)
    Zip::ZipFile.open(moodle_backup_path, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.add("moodle.xml", File.expand_path("../fixtures/moodle_backup/moodle.xml", __FILE__))
      zipfile.add("course_files/test.txt", File.expand_path("../fixtures/moodle_backup/course_files/test.txt", __FILE__))
      zipfile.add("course_files/folder/test.txt", File.expand_path("../fixtures/moodle_backup/course_files/folder/test.txt", __FILE__))
    end
    moodle_backup_path
  end

  def clean_tmp_folder
    Dir[File.expand_path("../tmp/*", __FILE__)].each do |file|
      FileUtils.rm_r file
    end
  end
end
