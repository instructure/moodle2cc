require 'spec_helper'

module Moodle2CC::CanvasCC
  describe TextOnlyQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('text_only_question')}

    it 'creates the question item xml for a true_false_question' do
      question.identifier = 300
      question.title = 'hi title and stuff'
      question.material = 'heressome material'

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil
      expect(xml.at_xpath('item/presentation/material/mattext[@texttype="text/html"]').text).to eq question.material
    end
  end
end