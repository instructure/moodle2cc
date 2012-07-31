module Moodle2CC::Canvas
  class Converter < Moodle2CC::CC::Converter
    def initialize(moodle_backup, destination_dir)
      super
      @resource_factory = Moodle2CC::ResourceFactory.new Moodle2CC::Canvas
    end

    def create_resources(resources_node)
      create_course_content(resources_node)
      @moodle_backup.course.question_categories.each do |question_category|
        create_question_bank_resource(resources_node, question_category)
      end
      super
    end

    def create_question_bank_resource(resources_node, question_category)
      question_bank = QuestionBank.new(question_category)
      if question_bank.questions.length > 0
        question_bank.create_resource_node(resources_node)
        question_bank.create_files(@export_dir)
      end
    end

    def create_course_content(resources_node)
      course = Course.new(@moodle_backup.course)
      course.create_resource_node(resources_node)
      course.create_files(@export_dir)
    end
  end
end
