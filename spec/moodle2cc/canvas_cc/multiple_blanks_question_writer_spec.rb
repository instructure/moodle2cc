require 'spec_helper'

module Moodle2CC::CanvasCC
  describe MultipleBlanksQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('fill_in_multiple_blanks_question')}

    it 'creates the question item xml for a multiple blanks question' do
      question.identifier = 4200
      question.title = 'hello'
      question.general_feedback = 'feedbacks'
      question.material = 'the first question is: [response1] and the second is: [response2]'

      answer1 = Moodle2CC::CanvasCC::Models::Answer.new
      answer1.id = '1'
      answer1.fraction = 1
      answer1.answer_text = 'i take specs seriously'
      answer1.feedback = 'feedfbavks'
      answer1.resp_ident = 'response1'

      answer2 = Moodle2CC::CanvasCC::Models::Answer.new
      answer2.id = '2'
      answer2.fraction = 1
      answer2.answer_text = 'imm the right one for the second'
      answer2.feedback = 'moar feedback'
      answer2.resp_ident = 'response2'
      question.answers = [answer1, answer2]

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil

      # first response
      response = xml.xpath('item/presentation/response_lid')[0]
      expect(response.attributes['rcardinality'].value).to eq 'Single'
      expect(response.attributes['ident'].value).to eq 'response1'
      expect(response.at_xpath("render_choice/response_label[@ident=\"#{answer1.id}\"]/material/mattext[@texttype=\"text/html\" and text()=\"#{answer1.answer_text}\"]")).not_to be_nil

      # second response
      response = xml.xpath('item/presentation/response_lid')[1]
      expect(response.attributes['rcardinality'].value).to eq 'Single'
      expect(response.attributes['ident'].value).to eq 'response2'
      expect(response.at_xpath("render_choice/response_label[@ident=\"#{answer2.id}\"]/material/mattext[@texttype=\"text/html\" and text()=\"#{answer2.answer_text}\"]")).not_to be_nil

      # Feedback
      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"Yes\"]/conditionvar/varequal[@respident=\"response1\" and text()=\"#{answer1.id}\"]/../..")
      expect(condition).not_to be_nil
      feedback = condition.at_xpath("displayfeedback[@feedbacktype=\"Response\" and @linkrefid=\"#{answer1.id}_fb\"]")
      expect(feedback).not_to be_nil

      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"Yes\"]/conditionvar/varequal[@respident=\"response2\" and text()=\"#{answer2.id}\"]/../..")
      expect(condition).not_to be_nil
      feedback = condition.at_xpath("displayfeedback[@feedbacktype=\"Response\" and @linkrefid=\"#{answer2.id}_fb\"]")
      expect(feedback).not_to be_nil

      feedback = xml.at_xpath("item/itemfeedback[@ident=\"#{answer1.id}_fb\"]/flow_mat/material/mattext[@texttype=\"text/html\"]")
      expect(feedback.text).to eq answer1.feedback
      feedback = xml.at_xpath("item/itemfeedback[@ident=\"#{answer2.id}_fb\"]/flow_mat/material/mattext[@texttype=\"text/html\"]")
      expect(feedback.text).to eq answer2.feedback

      # Conditions
      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"No\"]/conditionvar/varequal[@respident=\"response1\" and text()=\"#{answer1.id}\"]/../..")
      expect(condition).not_to be_nil
      setvar = condition.at_xpath('setvar[@varname="SCORE" and @action="Set" and text()="100"]')
      expect(setvar).not_to be_nil

      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"No\"]/conditionvar/varequal[@respident=\"response2\" and text()=\"#{answer2.id}\"]/../..")
      expect(condition).not_to be_nil
      setvar = condition.at_xpath('setvar[@varname="SCORE" and @action="Set" and text()="100"]')
      expect(setvar).not_to be_nil
    end
  end
end