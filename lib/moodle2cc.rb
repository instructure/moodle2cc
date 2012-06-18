require 'nokogiri'
require 'moodle2cc/version'
require 'moodle2cc/error'
require 'moodle2cc/migrator'

module Moodle2CC
  module Moodle
    autoload :Backup, 'moodle2cc/moodle/backup'
  end
end
