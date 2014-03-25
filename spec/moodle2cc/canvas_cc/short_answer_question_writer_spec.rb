require 'spec_helper'

module Moodle2CC::CanvasCC
  describe ShortAnswerQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('short_answer_question')}

    it 'creates the question item xml for an short_answer_question' do
      question.identifier = 422
      question.title = 'hi short answer tiftle'
      question.general_feedback = 'more constructive feedback'
      question.material = 'materials galore'

      answer = Moodle2CC::Moodle2::Models::Quizzes::Answer.new
      answer.id = 'answe_id'
      answer.answer_text = 'the answer'
      answer.feedback = 'so much feedback'
      answer.fraction = 1
      question.answers = [answer]

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

      # Conditions
      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"No\"]/conditionvar/varequal[@respident=\"response1\" and text()=\"#{answer.answer_text}\"]/../..")
      expect(condition).to_not be_nil
      set_var = condition.at_xpath('setvar[@varname="SCORE" and @action="Set" and text()="100"]')
      expect(set_var).to_not be_nil

      # Feedback
      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"Yes\"]/conditionvar/varequal[@respident=\"response1\" and text()=\"#{answer.answer_text}\"]/../..")
      expect(condition).to_not be_nil
      feedback = condition.at_xpath("displayfeedback[@feedbacktype=\"Response\" and @linkrefid=\"#{answer.id}_fb\"]")
      expect(feedback).to_not be_nil

      feedback = xml.at_xpath("item/itemfeedback[@ident=\"#{answer.id}_fb\"]/flow_mat/material/mattext[@texttype=\"text/html\"]")
      expect(feedback.text).to eq answer.feedback
    end
  end
end