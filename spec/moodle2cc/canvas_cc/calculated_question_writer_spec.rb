require 'spec_helper'

module Moodle2CC::CanvasCC
  describe CalculatedQuestionWriter do

    let(:question) { Moodle2CC::CanvasCC::Models::Question.create('calculated_question')}

    it 'creates the question item xml for a calculated question' do
      question.identifier = 42
      question.title = 'hi title'
      question.general_feedback = 'unconstructive feedback'
      question.material = 'materlia'

      question.correct_answer_format = '1'
      question.correct_answer_length = '2'
      question.tolerance = '0.01'

      answer = Moodle2CC::Moodle2::Models::Quizzes::Answer.new
      answer.answer_text = '{A}*{B}'
      answer.fraction = 1
      question.answers = [answer]

      question.dataset_definitions = [
        {
          :name => 'A',
          :options => 'uniform:1.0:10.0:1'
        },
        {
          :name => 'B',
          :options => 'uniform:10.0:20.0:1'
        }
      ]

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

      # Correct Condition
      condition = xml.root.at_xpath('resprocessing/respcondition[@title="correct"]')
      expect(condition.at_xpath('conditionvar/other')).to_not be_nil
      setvar = condition.at_xpath('setvar')
      expect(setvar.text).to eq '100'
      expect(setvar.attributes['varname'].value).to eq 'SCORE'
      expect(setvar.attributes['action'].value).to eq 'Set'

      condition = xml.root.at_xpath('resprocessing/respcondition[@title="incorrect"]')
      expect(condition.at_xpath('conditionvar/other')).to_not be_nil
      setvar = condition.at_xpath('setvar')
      expect(setvar.text).to eq '0'
      expect(setvar.attributes['varname'].value).to eq 'SCORE'
      expect(setvar.attributes['action'].value).to eq 'Set'

      # Calculations
      calculated = xml.root.at_xpath('itemproc_extension/calculated')
      expect(calculated.at_xpath('answer_tolerance').text).to eq question.tolerance

      # Formulas
      expect(calculated.at_xpath('formulas[@decimal_places="2"]')).to_not be_nil
      expect(calculated.at_xpath('formulas/formula["A*B"]')).to_not be_nil

      # Var
      a_var = calculated.at_xpath('vars/var[@scale="1"][@name="A"]')
      expect(a_var.at_xpath('min').text).to eq '1.0'
      expect(a_var.at_xpath('max').text).to eq '10.0'

      b_var = calculated.at_xpath('vars/var[@scale="1"][@name="B"]')
      expect(b_var.at_xpath('min').text).to eq '10.0'
      expect(b_var.at_xpath('max').text).to eq '20.0'
    end
  end
end