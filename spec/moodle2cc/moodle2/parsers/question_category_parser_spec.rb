# frozen_string_literal: true

require "spec_helper"

module Moodle2CC::Moodle2
  describe Parsers::QuestionCategoryParser do
    subject(:parser) { Parsers::QuestionCategoryParser.new(fixture_path(File.join("moodle2", "backup"))) }

    it "pareses quiz categories" do
      question_categories = subject.parse
      expect(question_categories.count).to eq 3
      category = question_categories[1]
      expect(category).to be_instance_of Models::Quizzes::QuestionCategory
      expect(category.id).to eq "2"
      expect(category.name).to eq "Default for SC"
      expect(category.context_id).to eq "15"
      expect(category.context_level).to eq "50"
      expect(category.context_instance_id).to eq "2"
      expect(category.info).to eq "The default category for questions shared in context 'SC'."
      expect(category.info_format).to eq "0"
      expect(category.stamp).to eq "10.0.21.141+140304213555+iMFEfs"
      expect(category.parent).to eq "0"
      expect(category.sort_order).to eq "999"

      expect(question_categories[0].questions.count).to eq 0
      expect(question_categories[1].questions.count).to eq 17

      questions_new_layout = question_categories[2].questions
      expect(questions_new_layout.count).to eq 1
      expect(questions_new_layout[0].bank_entry_id).to eq "1"
    end
  end
end
