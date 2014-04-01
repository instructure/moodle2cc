require 'spec_helper'

module Moodle2CC::CanvasCC
  describe TrueFalseQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('true_false_question')}

    it 'creates the question item xml for a true_false_question' do
      question.identifier = 42
      question.title = 'hi title'
      question.general_feedback = 'unconstructive feedback'
      question.material = 'materia'

      true_answer = Moodle2CC::CanvasCC::Models::Answer.new
      true_answer.id = 'tr00'
      true_answer.fraction = 1.0
      true_answer.answer_text = 'so true'
      true_answer.feedback = 'was there ever any doubt?'
      false_answer = Moodle2CC::CanvasCC::Models::Answer.new
      false_answer.id = 'furse'
      false_answer.fraction = 0.0
      false_answer.answer_text = 'falrse'
      false_answer.feedback = 'bakaaaa'
      question.answers = [true_answer, false_answer]

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil

      response = xml.at_xpath('item/presentation/response_lid')
      expect(response.attributes['rcardinality'].value).to eq 'Single'
      expect(response.attributes['ident'].value).to eq 'response1'

      expect(response.at_xpath("render_choice/response_label[@ident=\"#{true_answer.id}\"]/material/mattext[@texttype=\"text/html\" and text()=\"#{true_answer.answer_text}\"]")).not_to be_nil
      expect(response.at_xpath("render_choice/response_label[@ident=\"#{false_answer.id}\"]/material/mattext[@texttype=\"text/html\" and text()=\"#{false_answer.answer_text}\"]")).not_to be_nil

      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"No\"]/conditionvar/varequal[@respident=\"response1\" and text()=\"#{true_answer.id}\"]/../..")
      expect(condition).not_to be_nil
      feedback = condition.at_xpath("displayfeedback[@feedbacktype=\"Response\" and @linkrefid=\"#{true_answer.id}_fb\"]")
      expect(feedback).not_to be_nil
      setvar = condition.at_xpath('setvar[@varname="SCORE" and @action="Set" and text()="100"]')
      expect(setvar).not_to be_nil

      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"No\"]/conditionvar/varequal[@respident=\"response1\" and text()=\"#{false_answer.id}\"]/../..")
      expect(condition).not_to be_nil
      feedback = condition.at_xpath("displayfeedback[@feedbacktype=\"Response\" and @linkrefid=\"#{false_answer.id}_fb\"]")
      expect(feedback).not_to be_nil
      setvar = condition.at_xpath('setvar[@varname="SCORE" and @action="Set" and text()="0"]')
      expect(setvar).not_to be_nil

      feedback = xml.at_xpath("item/itemfeedback[@ident=\"#{true_answer.id}_fb\"]/flow_mat/material/mattext[@texttype=\"text/html\"]")
      expect(feedback.text).to eq true_answer.feedback

      feedback = xml.at_xpath("item/itemfeedback[@ident=\"#{false_answer.id}_fb\"]/flow_mat/material/mattext[@texttype=\"text/html\"]")
      expect(feedback.text).to eq false_answer.feedback
    end
  end
end