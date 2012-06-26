require 'pathname'
require 'erb'
require 'happymapper'
require 'builder'
require 'moodle2cc/version'
require 'moodle2cc/error'
require 'moodle2cc/migrator'

module Moodle2CC
  module CC
    autoload :CCHelper, 'moodle2cc/cc/cc_helper'
    autoload :Converter, 'moodle2cc/cc/converter'
    autoload :Assignment, 'moodle2cc/cc/assignment'
    autoload :DiscussionTopic, 'moodle2cc/cc/discussion_topic'
    autoload :WebContent, 'moodle2cc/cc/web_content'
    autoload :WebLink, 'moodle2cc/cc/web_link'
    autoload :Manifest, 'moodle2cc/cc/manifest'
    autoload :Organization, 'moodle2cc/cc/organization'
    autoload :Resource, 'moodle2cc/cc/resource'
    autoload :Item, 'moodle2cc/cc/item'
  end
  module Moodle
    autoload :Backup, 'moodle2cc/moodle/backup'
    autoload :Info, 'moodle2cc/moodle/info'
    autoload :Course, 'moodle2cc/moodle/course'
    autoload :Section, 'moodle2cc/moodle/section'
    autoload :Mod, 'moodle2cc/moodle/mod'
  end
end
