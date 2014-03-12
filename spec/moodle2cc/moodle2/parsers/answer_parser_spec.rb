require 'spec_helper'

module Moodle2CC::Moodle2::Parsers
  describe AnswerParser do

    it 'Parses Answers' do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      node = xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "15"]/plugin_qtype_truefalse_question/answers/answer')
      answer = subject.parse(node)
      expect(answer.id).to eq '24'
      expect(answer.answer_text).to eq 'True'
      expect(answer.fraction).to eq '1.0000000'
      expect(answer.feedback).to eq '<p>Correct</p>'
      expect(answer.feedback_format).to eq '1'
    end

  end
end