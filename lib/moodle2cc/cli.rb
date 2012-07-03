require 'thor'
require File.expand_path('../../moodle2cc', __FILE__)

module Moodle2CC
  class CLI < Thor
    desc "migrate MOODLE_BACKUP_ZIP EXPORT_DIR", "Migrates Moodle backup ZIP to IMS Common Cartridge package"

    def migrate(source, destination)
      migrator = Moodle2CC::Migrator.new source, destination
      migrator.migrate
      puts "#{source} converted to #{migrator.imscc_path}"
    end
  end
end
