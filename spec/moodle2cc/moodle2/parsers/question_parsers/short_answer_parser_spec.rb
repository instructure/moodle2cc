require 'spec_helper'
module Moodle2CC::Moodle2
  describe Parsers::QuestionParsers::ShortAnswerParser do
    let(:node) do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "9"]')
    end

    it 'parses a short answer question' do
      question = subject.parse_question(node)

      expect(question.type).to eq 'shortanswer'
      expect(question.answers.count).to eq 3
    end
  end
end