require 'zip'

module Moodle2CC::Moodle
  class Backup
    include HappyMapper

    attr_accessor :backup_path, :files

    tag 'MOODLE_BACKUP'
    has_one :info, Info
    has_one :course, Course

    def self.read(backup_path)
      xml = nil
      files = nil
      if File.directory?(backup_path)
        xml = File.read(File.join(backup_path, "moodle.xml"))
        files = Dir["#{backup_path}/**/*"].reject { |e| File.directory?(e) }.
            map { |e| e.sub("#{backup_path}/", '') }.select { |e| e =~ /^course_files/ }.
            map { |e| e.sub('course_files/', '') }.sort
      else
        Zip::File.open(backup_path) do |zipfile|
          xml = zipfile.read("moodle.xml")
          files = zipfile.entries.select { |e| e.name =~ /^course_files/ && !e.directory? }.
            map { |e| e.name.sub('course_files/', '') }.sort
        end
      end
      backup = parse(xml)
      backup.backup_path = backup_path
      backup.files = files
      backup
    end

    def copy_files_to(dir)
      if File.directory?(@backup_path)
        @files.each do |file|
          destination_file = File.join(dir, file)
          FileUtils.mkdir_p(File.dirname(destination_file))
          File.open(destination_file, 'wb') do |f|
            f.write File.read(File.join(@backup_path, "course_files/#{file}"))
          end
        end
      else
        Zip::File.open(@backup_path) do |zipfile|
          @files.each do |file|
            destination_file = File.join(dir, file)
            FileUtils.mkdir_p(File.dirname(destination_file))
            File.open(destination_file, 'wb') do |f|
              f.write zipfile.read("course_files/#{file}")
            end
          end
        end
      end
    end
  end
end
