require 'uri'
require 'cgi'
require 'ostruct'
require 'fileutils'
require 'erb'
require 'happymapper'
require 'builder'
require 'moodle2cc/version'
require 'moodle2cc/error'
require 'moodle2cc/migrator'

module Moodle2CC
  module CC
    autoload :Assessment, 'moodle2cc/cc/assessment'
    autoload :Assignment, 'moodle2cc/cc/assignment'
    autoload :CCHelper, 'moodle2cc/cc/cc_helper'
    autoload :Converter, 'moodle2cc/cc/converter'
    autoload :Course, 'moodle2cc/cc/course'
    autoload :DiscussionTopic, 'moodle2cc/cc/discussion_topic'
    autoload :Question, 'moodle2cc/cc/question'
    autoload :QuestionBank, 'moodle2cc/cc/question_bank'
    autoload :Resource, 'moodle2cc/cc/resource'
    autoload :WebContent, 'moodle2cc/cc/web_content'
    autoload :WebLink, 'moodle2cc/cc/web_link'
    autoload :Wiki, 'moodle2cc/cc/wiki'
  end
  module Moodle
    autoload :Backup, 'moodle2cc/moodle/backup'
    autoload :Course, 'moodle2cc/moodle/course'
    autoload :GradeItem, 'moodle2cc/moodle/grade_item'
    autoload :Info, 'moodle2cc/moodle/info'
    autoload :Mod, 'moodle2cc/moodle/mod'
    autoload :Question, 'moodle2cc/moodle/question'
    autoload :QuestionCategory, 'moodle2cc/moodle/question_category'
    autoload :Section, 'moodle2cc/moodle/section'
  end
end
