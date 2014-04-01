require 'spec_helper'

module Moodle2CC::CanvasCC
  describe EssayQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('essay_question')}

    it 'creates the question item xml for an essay_question' do
      question.identifier = 42
      question.title = 'hi title'
      question.general_feedback = 'unconstructive feedback'
      question.material = 'materia'

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil

      response = xml.at_xpath('item/presentation/response_str')
      expect(response.attributes['rcardinality'].value).to eq 'Single'
      expect(response.attributes['ident'].value).to eq 'response1'
      expect(response.at_xpath('render_fib/response_label').attributes['ident'].value).to eq 'answer1'

      condition = xml.root.at_xpath('resprocessing/respcondition[@continue="No"]')
      expect(condition.at_xpath('conditionvar/other')).to_not be_nil
    end
  end
end