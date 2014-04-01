require 'spec_helper'
module Moodle2CC::Moodle2
  describe Parsers::QuestionParsers::TrueFalseParser do
    let(:node) do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "15"]')
    end

    it 'parses a true false question' do
      question = subject.parse_question(node)

      expect(question.true_false_id).to eq '1'
      expect(question.true_answer).to eq '24'
      expect(question.false_answer).to eq '25'
    end

    it 'parses the answers' do
      question = subject.parse_question(node)
      expect(question.answers.count).to eq 2
    end
  end
end