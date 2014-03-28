require 'spec_helper'

module Moodle2CC::CanvasCC
  describe NumericalQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('numerical_question')}

    it 'creates the question item xml for a numerical question' do
      question.identifier = 9001
      question.title = 'its over nine thousannnd'
      question.general_feedback = 'ur totes awesome'
      question.material = 'this is a question, or is it?'

      answer1 = Moodle2CC::CanvasCC::Models::Answer.new
      answer1.id = 'answer1_id'
      answer1.answer_text = 20
      answer1.fraction = 1
      answer1.feedback = 'feedbak1'
      answer2 = Moodle2CC::CanvasCC::Models::Answer.new
      answer2.id = 'answer2_id'
      answer2.answer_text = 30
      answer2.fraction = 0
      answer2.feedback = 'also feedback2'
      question.answers = [answer1, answer2]

      question.tolerances = {'answer1_id' => 1, 'answer2_id' => 2}

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil

      response = xml.at_xpath('item/presentation/response_str')
      expect(response.attributes['rcardinality'].value).to eq 'Single'
      expect(response.attributes['ident'].value).to eq 'response1'
      expect(response.at_xpath('render_fib').attributes['fibtype'].value).to eq 'Decimal'
      expect(response.at_xpath('render_fib/response_label').attributes['ident'].value).to eq 'answer1'

      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"No\"]/displayfeedback[@linkrefid=\"#{answer1.id}_fb\"]/..")
      varequal = condition.at_xpath('conditionvar/or/varequal[@respident="response1"]')
      expect(varequal.text).to eq answer1.answer_text.to_s
      vargte = condition.at_xpath('conditionvar/or/and/vargte[@respident="response1"]')
      expect(vargte.text).to eq (answer1.answer_text.to_f - 1).to_s
      varlte = condition.at_xpath('conditionvar/or/and/varlte[@respident="response1"]')
      expect(varlte.text).to eq (answer1.answer_text.to_f + 1).to_s

      setvar = condition.at_xpath('setvar')
      expect(setvar.text).to eq '100'
      expect(setvar.attributes['varname'].value).to eq 'SCORE'
      expect(setvar.attributes['action'].value).to eq 'Set'

      condition = xml.at_xpath("item/resprocessing/respcondition[@continue=\"No\"]/displayfeedback[@linkrefid=\"#{answer2.id}_fb\"]/..")
      varequal = condition.at_xpath('conditionvar/or/varequal[@respident="response1"]')
      expect(varequal.text).to eq answer2.answer_text.to_s
      vargte = condition.at_xpath('conditionvar/or/and/vargte[@respident="response1"]')
      expect(vargte.text).to eq (answer2.answer_text.to_f - 2).to_s
      varlte = condition.at_xpath('conditionvar/or/and/varlte[@respident="response1"]')
      expect(varlte.text).to eq (answer2.answer_text.to_f + 2).to_s

      setvar = condition.at_xpath('setvar')
      expect(setvar.text).to eq '0'
      expect(setvar.attributes['varname'].value).to eq 'SCORE'
      expect(setvar.attributes['action'].value).to eq 'Set'
    end
  end
end