require 'thor'

module Moodle2CC
  class CLI < Thor
    desc "migrate MOODLE_BACKUP_ZIP EXPORT_DIR", "Migrates Moodle backup ZIP to IMS Common Cartridge package"
    method_option :format, :default => 'cc'
    method_options :format => :string
    def migrate(source, destination)
      migrator = Moodle2CC::Migrator.new source, destination, options
      migrator.migrate
      puts "#{source} converted to #{migrator.imscc_path}"
    end
  end
end
