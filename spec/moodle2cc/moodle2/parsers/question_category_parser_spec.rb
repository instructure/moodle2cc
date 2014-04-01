require 'spec_helper'

module Moodle2CC::Moodle2
  describe Parsers::QuestionCategoryParser do
    subject(:parser) {Parsers::QuestionCategoryParser.new(fixture_path(File.join('moodle2', 'backup')))}

    it 'pareses quiz categories' do
      question_categories = subject.parse
      expect(question_categories.count).to eq 2
      category = question_categories.last
      expect(category).to be_instance_of Models::Quizzes::QuestionCategory
      expect(category.id).to eq '2'
      expect(category.name).to eq 'Default for SC'
      expect(category.context_id).to eq '15'
      expect(category.context_level).to eq '50'
      expect(category.context_instance_id).to eq '2'
      expect(category.info).to eq 'The default category for questions shared in context \'SC\'.'
      expect(category.info_format).to eq '0'
      expect(category.stamp).to eq '10.0.21.141+140304213555+iMFEfs'
      expect(category.parent).to eq '0'
      expect(category.sort_order).to eq '999'

      expect(category.questions.count).to eq 18
    end

  end
end