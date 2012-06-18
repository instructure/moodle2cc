require 'zip/zipfilesystem'

module Moodle2CC::Moodle
  class Backup
    attr_accessor :xml

    def self.parse(backup_file)
      backup = Backup.new
      backup.parse backup_file
      backup
    end

    def info
      @xml.xpath('//MOODLE_BACKUP/INFO').first
    end

    def course
      @xml.xpath('//MOODLE_BACKUP/COURSE').first
    end

    def parse(backup_file)
      Zip::ZipFile.open(backup_file) do |zipfile|
        @xml = Nokogiri::XML(zipfile.file.read("moodle.xml"))
      end
    end
  end
end
