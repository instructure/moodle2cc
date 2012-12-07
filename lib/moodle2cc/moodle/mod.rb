module Moodle2CC::Moodle
  class Mod
    include HappyMapper

    attr_accessor :course

    class QuestionInstance
      include HappyMapper

      attr_accessor :mod

      tag 'QUESTION_INSTANCES/QUESTION_INSTANCE'
      element :id, Integer, :tag => 'ID'
      element :question_id, Integer, :tag => 'QUESTION'
      element :grade, Integer, :tag => 'GRADE'

      def question
        @question ||= mod.course.question_categories.map do |qc|
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

    class Option
      include HappyMapper

      tag 'OPTIONS/OPTION'
      element :id, Integer, :tag => 'ID'
      element :text, String, :tag => 'TEXT'
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
    element :summary, String, :tag => 'SUMMARY'
    element :alltext, String, :tag => 'ALLTEXT'
    element :text, String, :tag => 'TEXT'
    element :content, String, :tag => 'CONTENT'
    element :assignment_type, String, :tag => 'ASSIGNMENTTYPE'
    element :reference, String, :tag => 'REFERENCE'
    element :intro, String, :tag => 'INTRO'
    element :resubmit, Boolean, :tag => 'RESUBMIT'
    element :prevent_late, Boolean, :tag => 'PREVENTLATE'
    element :grade, Integer, :tag => 'GRADE'
    element :number_of_attachments, Integer, :tag => 'NATTACHMENTS'
    element :number_of_student_assessments, Integer, :tag => 'NSASSESSMENTS'
    element :anonymous, Boolean, :tag => 'ANONYMOUS'
    element :submission_start, Integer, :tag => 'SUBMISSIONSTART'
    element :submission_end, Integer, :tag => 'SUBMISSIONEND'
    element :assessment_start, Integer, :tag => 'ASSESSMENTSTART'
    element :assessment_end, Integer, :tag => 'ASSESSMENTEND'
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
    has_many :questions, Question
    has_many :pages, Page
    has_many :options, Option

    after_parse do |mod|
      mod.question_instances.each { |question_instance| question_instance.mod = mod }
    end

    def section_mod
      course.sections.map { |section| section.mods.find { |mod| mod.instance_id == id && mod.mod_type == mod_type } }.compact.first
    end

    def grade_item
      course.grade_items.find { |grade_item| grade_item.item_instance == id }
    end

    def questions
      if mod_type == 'questionnaire'
        @questions.sort! { |a,b| a.position <=> b.position }
        return @questions
      end
      if mod_type == 'choice'
        question = Question.new
        question.id = "choice_question_#{@id}"
        question.name = @name
        question.text = @text
        question.type = @mod_type
        question.grade = 1
        question.answers = []
        @options.each do |option|
          answer = Question::Answer.new
          answer.id = option.id
          answer.text = option.text
          question.answers << answer
        end
        @questions = [question]
      else
        question_instances.reject!{ |qi| qi.question.nil? }
        @questions = question_instances.map do |qi|
          question = qi.question
          question.grade = qi.grade
          question.instance_id = qi.id
          question
        end
      end
    end
  end
end
