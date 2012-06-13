require 'zip/zipfilesystem'
require 'multi_xml'

module Moodle2CC::Moodle
  class Backup
    attr_accessor :attributes

    def initialize(backup_file)
      @backup_file = backup_file
      parse
    end

  private

    def parse
      Zip::ZipFile.open(@backup_file) do |zipfile|
        self.attributes = MultiXml.parse(zipfile.file.read("moodle.xml"))
      end
    end
  end
end
