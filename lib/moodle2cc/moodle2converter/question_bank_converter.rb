module Moodle2CC::Moodle2Converter
  class QuestionBankConverter
    include ConverterHelper

    def convert(moodle_category)
      canvas_bank = Moodle2CC::CanvasCC::Models::QuestionBank.new

      canvas_bank.identifier = generate_unique_identifier_for(moodle_category.id, QUESTION_BANK_SUFFIX)
      canvas_bank.title = truncate_text(moodle_category.name)

      question_converter = Moodle2CC::Moodle2Converter::QuestionConverters::QuestionConverter.new
      moodle_category.questions.each do |moodle_question|
        item = question_converter.convert(moodle_question)
        case item
        when Moodle2CC::CanvasCC::Models::Question
          canvas_bank.questions << item
        when Moodle2CC::CanvasCC::Models::QuestionGroup
          canvas_bank.question_groups << item
        end
      end

      canvas_bank.question_groups.each do |question_group|
        if question_group.group_type == 'random_short_answer'
          question_group.questions = canvas_bank.questions.select{|q| q.question_type == 'short_answer_question'}
        end
      end

      canvas_bank
    end
  end
end