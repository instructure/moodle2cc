# frozen_string_literal: true

module Moodle2CC::Moodle2
  class Parsers::QuestionCategoryParser
    include Parsers::ParserHelper

    QUESTIONS_XML = "questions.xml"

    def initialize(backup_dir)
      @backup_dir = backup_dir
    end

    def parse
      File.open(File.join(@backup_dir, QUESTIONS_XML)) do |f|
        root_xml = Nokogiri::XML(f)
        root_xml.search("/question_categories/question_category").map { |node| question_category_parser(node) }
      end
    end

    private

    def question_category_parser(node)
      category = Models::Quizzes::QuestionCategory.new
      category.id = node.at_xpath("@id").value
      category.name = parse_text(node, "name")
      category.context_id = parse_text(node, "contextid")
      category.context_level = parse_text(node, "contextlevel")
      category.context_instance_id = parse_text(node, "contextinstanceid")
      category.info = parse_text(node, "info")
      category.info_format = parse_text(node, "infoformat")
      category.stamp = parse_text(node, "stamp")
      category.parent = parse_text(node, "parent")
      category.sort_order = parse_text(node, "sortorder")

      category.questions += node.search("./questions/question").filter_map { |question_node| question_parser(question_node) }
      category.questions += node.search("question_bank_entries/question_bank_entry").map do |question_bank_entry|
        question_bank_entry.search("question_version/question_versions").map do |question_versions|
          question_versions.search("questions/question").map do |question_node|
            bank_entry_reference = Nokogiri::XML::DocumentFragment.parse("<bank_entry_id>#{question_bank_entry.at_xpath("@id").value}</bank_entry_id>")
            question_node.add_child(bank_entry_reference)
            question_parser(question_node)
          end
        end
      end.flatten.compact

      category.questions = category.questions.flatten

      category
    end

    def question_parser(node)
      Parsers::QuestionParsers::QuestionParser.parse(node)
    rescue Exception => e
      Moodle2CC::OutputLogger.logger.info e.message
      nil
    end
  end
end
