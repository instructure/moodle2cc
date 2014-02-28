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
  module CanvasCC
    autoload :ImsManifestGenerator, 'moodle2cc/canvas_cc/ims_manifest_generator'
    autoload :CartridgeCreator, 'moodle2cc/canvas_cc/cartridge_creator'
    autoload :CourseSettingWriter, 'moodle2cc/canvas_cc/course_setting_writer'
    autoload :ModuleMetaWriter, 'moodle2cc/canvas_cc/module_meta_writer'
    autoload :FileMetaWriter, 'moodle2cc/canvas_cc/file_meta_writer'
    autoload :CanvasExportWriter, 'moodle2cc/canvas_cc/canvas_export_writer'
    autoload :PageWriter, 'moodle2cc/canvas_cc/page_writer'
    autoload :DiscussionWriter, 'moodle2cc/canvas_cc/discussion_writer'
    module Model
      autoload :Course, 'moodle2cc/canvas_cc/model/course'
      autoload :Assignment, 'moodle2cc/canvas_cc/model/assignment'
      autoload :DiscussionTopic, 'moodle2cc/canvas_cc/model/discussion_topic'
      autoload :Question, 'moodle2cc/canvas_cc/model/question'
      autoload :WebContent, 'moodle2cc/canvas_cc/model/web_content'
      autoload :WebLink, 'moodle2cc/canvas_cc/model/web_link'
      autoload :Resource, 'moodle2cc/canvas_cc/model/resource'
      autoload :CanvasModule, 'moodle2cc/canvas_cc/model/canvas_module'
      autoload :CanvasFile, 'moodle2cc/canvas_cc/model/canvas_file'
      autoload :Page, 'moodle2cc/canvas_cc/model/page'
      autoload :Discussion, 'moodle2cc/canvas_cc/model/discussion'
    end
  end
  module Moodle2
    autoload :Extractor, 'moodle2cc/moodle2/extractor'
    autoload :CourseParser, 'moodle2cc/moodle2/course_parser'
    autoload :SectionParser, 'moodle2cc/moodle2/section_parser'
    autoload :FileParser, 'moodle2cc/moodle2/file_parser'
    autoload :PageParser, 'moodle2cc/moodle2/page_parser'
    autoload :ForumParser, 'moodle2cc/moodle2/forum_parser'
    module Model
      autoload :Course, 'moodle2cc/moodle2/model/course'
      autoload :Section, 'moodle2cc/moodle2/model/section'
      autoload :Moodle2File, 'moodle2cc/moodle2/model/moodle2_file'
      autoload :Page, 'moodle2cc/moodle2/model/page'
      autoload :Forum, 'moodle2cc/moodle2/model/forum'
    end
  end
  module Moodle2Converter
    autoload :Migrator, 'moodle2cc/moodle2converter/migrator'
    autoload :CourseConverter, 'moodle2cc/moodle2converter/course_converter'
    autoload :SectionConverter, 'moodle2cc/moodle2converter/section_converter'
    autoload :FileConverter, 'moodle2cc/moodle2converter/file_converter'
    autoload :PageConverter, 'moodle2cc/moodle2converter/page_converter'
  end
end
