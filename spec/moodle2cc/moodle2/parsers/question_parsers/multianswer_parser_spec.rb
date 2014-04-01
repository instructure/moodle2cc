require 'spec_helper'
module Moodle2CC::Moodle2
  describe Parsers::QuestionParsers::MultianswerParser do
    let(:node) do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "4"]')
    end

    it 'parses a multianswer question' do
      question = subject.parse_question(node)

      expect(question.type).to eq 'multianswer'
      expect(question.embedded_question_references).to eq %w{5 6 7 8 9}
    end
  end
end