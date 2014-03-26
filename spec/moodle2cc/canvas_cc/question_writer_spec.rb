require 'spec_helper'

module Moodle2CC::CanvasCC
  describe QuestionWriter do
    subject { Moodle2CC::CanvasCC::QuestionWriter }
    let(:question) { Moodle2CC::CanvasCC::Models::Question.new }

    class FooBarWriter < QuestionWriter
      def self.write_additional_nodes(item_node, question)
        write_standard_answer_feedbacks(item_node, question)
        item_node.randomnode
      end

      def self.write_responses(item_node, question)
        item_node.mockresponsesnode
      end

      def self.write_response_conditions(item_node, question)
        item_node.mockresponseconditionsnode
      end
    end

    before :each do
      question.question_type = 'foobar_type'
      FooBarWriter.register_writer_type 'foobar_type'
    end

    it 'registers a question type for writing' do
      FooBarWriter.stub(:write_question_item_xml)
      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end
      expect(FooBarWriter).to have_received(:write_question_item_xml)
    end

    it 'raises an exception for unknown converter types' do
      question.question_type = 'nonexistenttype'

      expect {
        Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
          QuestionWriter.write_question(node, question)
        end
      }.to raise_exception
    end

    it 'writes item metadata' do
      question.identifier = 'blah'
      question.title = 'titled'
      question.points_possible = 41
      question.assessment_question_identifierref = 'reffed'

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/@ident').value).to eq question.identifier.to_s
      expect(xml.at_xpath('item/@title').value).to eq question.title
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"question_type\" and fieldentry=\"#{question.question_type}\"]")).to_not be_nil
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"points_possible\" and fieldentry=\"#{question.points_possible}\"]")).to_not be_nil
      expect(xml.at_xpath("item/itemmetadata/qtimetadata/qtimetadatafield[fieldlabel=\"assessment_question_identifierref\" and fieldentry=\"#{question.assessment_question_identifierref}\"]")).to_not be_nil
    end

    it 'writes item presentation node' do
      question.material = 'bunch of stuff in here'

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/presentation/material/mattext[@texttype="text/html"]').text).to eq question.material
      expect(xml.at_xpath('item/presentation/mockresponsesnode')).to_not be_nil
    end

    it 'writes item resprocessing node' do
      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      outcome = xml.at_xpath('item/resprocessing/outcomes/decvar')
      expect(outcome.attributes['maxvalue'].value).to eq '100'
      expect(outcome.attributes['minvalue'].value).to eq '0'
      expect(outcome.attributes['varname'].value).to eq 'SCORE'
      expect(outcome.attributes['vartype'].value).to eq 'Decimal'

      expect(xml.at_xpath('item/resprocessing/mockresponseconditionsnode')).to_not be_nil
    end

    it 'writes general feedback' do
      question.general_feedback = 'here, have some (un)helpful feedback'

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      general_feedback = xml.at_xpath('item/resprocessing/respcondition[1]')
      expect(general_feedback.attributes['continue'].value).to eq 'Yes'
      expect(general_feedback.at_xpath('conditionvar/other')).to_not be_nil
      expect(general_feedback.at_xpath('displayfeedback').attributes['feedbacktype'].value).to eq 'Response'
      expect(general_feedback.at_xpath('displayfeedback').attributes['linkrefid'].value).to eq 'general_fb'

      general_feedback = xml.at_xpath('item/itemfeedback[@ident="general_fb"]')
      expect(general_feedback).to_not be_nil
      expect(general_feedback.at_xpath('flow_mat/material/mattext[@texttype="text/html"]').text).to eq question.general_feedback
    end

    it 'writes standard answer feedback if called' do
      answer = Moodle2CC::CanvasCC::Models::Answer.new
      answer.id = 'an_id'
      answer.feedback = 'much feedback'
      question.answers = [answer]

      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      feedback = xml.at_xpath("item/itemfeedback[@ident=\"#{answer.id}_fb\"]/flow_mat/material/mattext[@texttype=\"text/html\"]")
      expect(feedback.text).to eq answer.feedback
    end

    it 'writes additional nodes' do
      xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |node|
        QuestionWriter.write_question(node, question)
      end.doc

      expect(xml.at_xpath('item/randomnode')).to_not be_nil
    end

  end
end