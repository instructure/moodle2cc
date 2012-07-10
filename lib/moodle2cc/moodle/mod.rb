module Moodle2CC::Moodle
  class Mod
    include HappyMapper

    attr_accessor :course

    class QuestionInstance
      include HappyMapper

      attr_accessor :mod

      tag 'QUESTION_INSTANCES/QUESTION_INSTANCE'
      element :question_id, Integer, :tag => 'QUESTION'
      element :grade, Integer, :tag => 'GRADE'

      def question
        mod.course.question_categories.map do |qc|
          qc.questions.find { |q| q.id == question_id }
        end.compact.first
      end
    end

    class Page
      include HappyMapper

      tag 'ENTRIES/ENTRY/PAGES/PAGE'
      element :page_name, String, :tag => 'PAGENAME'
      element :version, Integer, :tag => 'VERSION'
      element :content, String, :tag => 'CONTENT'
    end

    tag 'MODULES/MOD'
    element :id, Integer, :tag => 'ID'
    element :var1, Integer, :tag => 'VAR1'
    element :var2, Integer, :tag => 'VAR2'
    element :var3, Integer, :tag => 'VAR3'
    element :var4, Integer, :tag => 'VAR4'
    element :var5, Integer, :tag => 'VAR5'
    element :mod_type, String, :tag => 'MODTYPE'
    element :type, String, :tag => 'TYPE'
    element :name, String, :tag => 'NAME'
    element :description, String, :tag => 'DESCRIPTION'
    element :alltext, String, :tag => 'ALLTEXT'
    element :content, String, :tag => 'CONTENT'
    element :assignment_type, String, :tag => 'ASSIGNMENTTYPE'
    element :reference, String, :tag => 'REFERENCE'
    element :intro, String, :tag => 'INTRO'
    element :resubmit, Boolean, :tag => 'RESUBMIT'
    element :prevent_late, Boolean, :tag => 'PREVENTLATE'
    element :grade, Integer, :tag => 'GRADE'
    element :time_due, Integer, :tag => 'TIMEDUE'
    element :time_available, Integer, :tag => 'TIMEAVAILABLE'
    element :time_open, Integer, :tag => 'TIMEOPEN'
    element :time_close, Integer, :tag => 'TIMECLOSE'
    element :time_limit, Integer, :tag => 'TIMELIMIT'
    element :attempts_number, Integer, :tag => 'ATTEMPTS_NUMBER'
    element :grade_method, Integer, :tag => 'GRADEMETHOD'
    element :password, String, :tag => 'PASSWORD'
    element :subnet, String, :tag => 'SUBNET'
    element :shuffle_answers, Boolean, :tag => 'SHUFFLEANSWERS'
    element :page_name, String, :tag => 'PAGENAME'
    has_many :question_instances, QuestionInstance
    has_many :pages, Page

    after_parse do |mod|
      mod.question_instances.each { |question_instance| question_instance.mod = mod }
    end

    def section_mod
      course.sections.map { |section| section.mods.find { |mod| mod.instance_id == id && mod.mod_type == mod_type } }.compact.first
    end

    def grade_item
      course.grade_items.find { |grade_item| grade_item.item_instance == id }
    end
  end
end
