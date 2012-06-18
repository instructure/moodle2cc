require 'nokogiri'
require 'moodle2cc/version'
require 'moodle2cc/error'
require 'moodle2cc/migrator'

module Moodle2CC
  module CC
    autoload :CCHelper, 'moodle2cc/cc/cc_helper'
    autoload :Manifest, 'moodle2cc/cc/manifest'
    autoload :Organization, 'moodle2cc/cc/organization'
    autoload :Resource, 'moodle2cc/cc/resource'
    autoload :Item, 'moodle2cc/cc/item'
    autoload :File, 'moodle2cc/cc/file'
  end
  module Moodle
    autoload :Backup, 'moodle2cc/moodle/backup'
  end
end
