require 'spec_helper'
module Moodle2CC::Moodle2
  describe Parsers::QuestionParsers::NumericalParser do
    let(:node) do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "13"]')
    end

    it 'parses a numerical question' do
      question = subject.parse_question(node)

      expect(question.is_a?(Moodle2CC::Moodle2::Models::Quizzes::NumericalQuestion)).to be_truthy
      expect(question.qtype).to eq 'numerical'

      expect(question.answers.count).to eq 3
      expect(question.tolerances.count).to eq 3

      expect(question.tolerances["19"]).to eq "1"
      expect(question.tolerances["20"]).to eq "0"
      expect(question.tolerances["21"]).to eq "0"
    end
  end
end