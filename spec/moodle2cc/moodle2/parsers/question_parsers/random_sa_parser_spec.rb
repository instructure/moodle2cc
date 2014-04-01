require 'spec_helper'
module Moodle2CC::Moodle2
  describe Parsers::QuestionParsers::RandomSAParser do
    let(:node) do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "17"]')
    end

    it 'parses a random short answer question' do
      question = subject.parse_question(node)

      expect(question.is_a?(Moodle2CC::Moodle2::Models::Quizzes::RandomSAQuestion)).to be_true
      expect(question.qtype).to eq 'randomsamatch'

      expect(question.choose).to eq '2'
    end
  end
end