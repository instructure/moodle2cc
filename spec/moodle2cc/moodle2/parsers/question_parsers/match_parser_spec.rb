require 'spec_helper'
module Moodle2CC::Moodle2
  describe Parsers::QuestionParsers::MatchParser do
    let(:node) do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "11"]')
    end

    it 'parses a match question' do
      question = subject.parse_question(node)

      expect(question.type).to eq 'match'
      expect(question.matches.count).to eq 3
      question.matches.each do |m|
        expect(m[:question_text_format]).to eq "1"
      end

      expect(question.matches[0][:id]).to eq "1"
      expect(question.matches[1][:id]).to eq "2"
      expect(question.matches[2][:id]).to eq "3"

      expect(question.matches[0][:question_text]).to eq "<p>Question One</p>"
      expect(question.matches[1][:question_text]).to eq "<p>Question 2</p>"
      expect(question.matches[2][:question_text]).to eq "<p>Question 3</p>"

      expect(question.matches[0][:answer_text]).to eq "Answer One"
      expect(question.matches[1][:answer_text]).to eq "Answer 2"
      expect(question.matches[2][:answer_text]).to eq "Answer 3"
    end
  end
end