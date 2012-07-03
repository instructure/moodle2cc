require 'uri'
require 'fileutils'
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
    autoload :Resource, 'moodle2cc/cc/resource'
    autoload :Assignment, 'moodle2cc/cc/assignment'
    autoload :Course, 'moodle2cc/cc/course'
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
    autoload :GradeItem, 'moodle2cc/moodle/grade_item'
    autoload :Section, 'moodle2cc/moodle/section'
    autoload :Mod, 'moodle2cc/moodle/mod'
    autoload :QuestionCategory, 'moodle2cc/moodle/question_category'
    autoload :Question, 'moodle2cc/moodle/question'
  end
end
