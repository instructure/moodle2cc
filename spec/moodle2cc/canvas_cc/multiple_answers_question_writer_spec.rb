require 'spec_helper'

module Moodle2CC::CanvasCC
  describe MultipleAnswersQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('multiple_answers_question')}

    it 'creates the question item xml for a multiple_choice_question' do
      question.identifier = 420
      question.title = 'hello'
      question.general_feedback = 'feedbacks'
      question.material = 'materiaru'

      answer1 = Moodle2CC::CanvasCC::Models::Answer.new
      answer1.id = '1'
      answer1.answer_text = 'something'
      answer1.fraction = '0.5'
      answer2 = Moodle2CC::CanvasCC::Models::Answer.new
      answer2.id = '2'
      answer2.answer_text = 'something else'
      answer2.fraction = '0'
      answer3 = Moodle2CC::CanvasCC::Models::Answer.new
      answer3.id = '3'
      answer3.answer_text = 'something something else'
      answer3.fraction = '0.5'
      question.answers = [answer1, answer2, answer3]

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil

      response = xml.at_xpath('item/presentation/response_lid')
      expect(response.attributes['rcardinality'].value).to eq 'Multiple'
      expect(response.attributes['ident'].value).to eq 'response1'

      expect(response.at_xpath("render_choice/response_label[@ident=\"#{answer1.id}\"]/material/mattext[@texttype=\"text/html\" and text()=\"#{answer1.answer_text}\"]")).not_to be_nil
      expect(response.at_xpath("render_choice/response_label[@ident=\"#{answer2.id}\"]/material/mattext[@texttype=\"text/html\" and text()=\"#{answer2.answer_text}\"]")).not_to be_nil
      expect(response.at_xpath("render_choice/response_label[@ident=\"#{answer3.id}\"]/material/mattext[@texttype=\"text/html\" and text()=\"#{answer3.answer_text}\"]")).not_to be_nil

      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"No\"]")
      expect(condition.at_xpath("conditionvar/and/varequal[@respident=\"response1\" and text()=\"#{answer1.id}\"]")).not_to be_nil
      expect(condition.at_xpath("conditionvar/and/not/varequal[@respident=\"response1\" and text()=\"#{answer2.id}\"]")).not_to be_nil
      expect(condition.at_xpath("conditionvar/and/varequal[@respident=\"response1\" and text()=\"#{answer3.id}\"]")).not_to be_nil
    end
  end
end