require 'zip/zipfilesystem'
require 'multi_xml'
require 'hashie/mash'

module Moodle2CC::Moodle
  class Backup
    attr_accessor :attributes

    def self.parse(backup_file)
      backup = Backup.new
      backup.parse backup_file
      backup
    end

    def root
      @attributes.moodle_backup
    end

    def course
      root.course
    end

    def parse(backup_file)
      Zip::ZipFile.open(backup_file) do |zipfile|
        attrs = MultiXml.parse(zipfile.file.read("moodle.xml"))
        attrs = Hash[attrs.map { |k,v| [k.downcase, downcase_hash_keys(v)] }]
        @attributes = Hashie::Mash.new attrs
      end
    end

  private

    def downcase_hash_keys(value)
      case value
      when Array
        value.map { |v| downcase_hash_keys(v) }
      when Hash
        Hash[value.map { |k, v| [k.downcase, downcase_hash_keys(v)] }]
      else
        value
      end
    end
  end
end
