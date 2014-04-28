require 'spec_helper'

module Moodle2CC::CanvasCC
  describe MultipleDropdownsQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('multiple_dropdowns_question')}

    it 'creates the question item xml for a multiple_dropdowns_question' do
      question.identifier = 4200
      question.title = 'hello'
      question.general_feedback = 'feedbacks'
      question.material = 'the first question is [response1] and the second is [response2]'
      question.answers = []
      question.responses = [
        {:id => "response1", :choices => [
          {:id => "3_choice_0_0", :text => "1"},
          {:id => "3_choice_0_1", :text => "2"}
        ]},
        {:id => "response2", :choices => [
          {:id => "3_choice_1_0", :text => "1"},
          {:id => "3_choice_1_1", :text => "2"}
        ]}
      ]

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil

      # first response
      response = xml.xpath('item/presentation/response_lid')[0]
      expect(response.attributes['ident'].value).to eq 'response_response1'
      expect(response.at_xpath("render_choice/response_label[@ident=\"3_choice_0_0\"]/material/mattext[@texttype=\"text/plain\" and text()=\"1\"]")).not_to be_nil
      expect(response.at_xpath("render_choice/response_label[@ident=\"3_choice_0_1\"]/material/mattext[@texttype=\"text/plain\" and text()=\"2\"]")).not_to be_nil

      # second response
      response = xml.xpath('item/presentation/response_lid')[1]
      expect(response.attributes['ident'].value).to eq 'response_response2'
      expect(response.at_xpath("render_choice/response_label[@ident=\"3_choice_1_0\"]/material/mattext[@texttype=\"text/plain\" and text()=\"1\"]")).not_to be_nil
      expect(response.at_xpath("render_choice/response_label[@ident=\"3_choice_1_1\"]/material/mattext[@texttype=\"text/plain\" and text()=\"2\"]")).not_to be_nil
    end
  end
end