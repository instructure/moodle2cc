require 'zip/zipfilesystem'

module Moodle2CC::Moodle
  class Backup
    include HappyMapper

    tag 'MOODLE_BACKUP'
    has_one :info, Info
    has_one :course, Course

    def self.read(backup_file)
      Zip::ZipFile.open(backup_file) do |zipfile|
        xml = zipfile.file.read("moodle.xml")
        parse xml
      end
    end
  end
end
