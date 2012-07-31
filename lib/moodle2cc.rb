require 'builder'
require 'cgi'
require 'erb'
require 'fileutils'
require 'happymapper'
require 'logger'
require 'nokogiri'
require 'ostruct'
require 'rdiscount'
require 'uri'

require 'moodle2cc/error'
require 'moodle2cc/logger'
require 'moodle2cc/migrator'

module Moodle2CC
  class OpenStruct < ::OpenStruct
    if defined? id
      undef id
    end
  end

  autoload :ResourceFactory, 'moodle2cc/resource_factory'

  module CC
    autoload :Assessment, 'moodle2cc/cc/assessment'
    autoload :Assignment, 'moodle2cc/cc/assignment'
    autoload :CCHelper, 'moodle2cc/cc/cc_helper'
    autoload :Converter, 'moodle2cc/cc/converter'
    autoload :Course, 'moodle2cc/cc/course'
    autoload :DiscussionTopic, 'moodle2cc/cc/discussion_topic'
    autoload :Label, 'moodle2cc/cc/label'
    autoload :Question, 'moodle2cc/cc/question'
    autoload :Resource, 'moodle2cc/cc/resource'
    autoload :WebContent, 'moodle2cc/cc/web_content'
    autoload :WebLink, 'moodle2cc/cc/web_link'
    autoload :Wiki, 'moodle2cc/cc/wiki'
  end
  module Canvas
    autoload :Assessment, 'moodle2cc/canvas/assessment'
    autoload :Assignment, 'moodle2cc/canvas/assignment'
    autoload :Converter, 'moodle2cc/canvas/converter'
    autoload :Course, 'moodle2cc/canvas/course'
    autoload :DiscussionTopic, 'moodle2cc/canvas/discussion_topic'
    autoload :Label, 'moodle2cc/canvas/label'
    autoload :Question, 'moodle2cc/canvas/question'
    autoload :QuestionBank, 'moodle2cc/canvas/question_bank'
    autoload :QuestionGroup, 'moodle2cc/canvas/question_group'
    autoload :Resource, 'moodle2cc/canvas/resource'
    autoload :WebContent, 'moodle2cc/canvas/web_content'
    autoload :WebLink, 'moodle2cc/canvas/web_link'
    autoload :Wiki, 'moodle2cc/canvas/wiki'
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
