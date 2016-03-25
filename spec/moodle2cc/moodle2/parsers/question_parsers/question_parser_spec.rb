require 'spec_helper'

module Moodle2CC::Moodle2::Parsers::QuestionParsers
  describe QuestionParser do

    class FooBarParser < QuestionParser
    end

    it 'registers a question type for object creation' do
      node = Nokogiri::XML('<question><qtype>foobar</qtype></question>')
      parser = FooBarParser.new
      allow(parser).to receive(:parse_question)
      allow(FooBarParser).to receive(:new).and_return(parser)
      FooBarParser.register_parser_type 'foobar'
      QuestionParser.parse(node)
      expect(parser).to have_received(:parse_question)
    end

    it 'raises an exception for unknown parser types' do
      node = Nokogiri::XML('<question><qtype>non_existing_parser_type</qtype></question>')
      expect { FooBarParser.parse(node) }.to raise_exception
    end


    it 'parses a quiz question' do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      node = xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "15"]')
      question = subject.parse_question(node)

      expect(question.id).to eq '15'
      expect(question.parent).to eq '0'
      expect(question.name).to eq 'True/False Question'
      expect(question.question_text).to eq '<p>True == True</p>'
      expect(question.question_text_format).to eq '1'
      expect(question.general_feedback).to eq '<p>feedback</p>'
      expect(question.default_mark).to eq '1.0000000'
      expect(question.penalty).to eq '1.0000000'
      expect(question.qtype).to eq 'truefalse'
      expect(question.length).to eq '1'
      expect(question.stamp).to eq '10.0.21.141+140304215800+p3jSSa'
      expect(question.version).to eq '10.0.21.141+140304215801+FQKIDE'
    end

    it 'parses essay questions as standard questions' do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      node = xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "10"]')
      question = subject.parse_question(node)

      expect(question.is_a?(Moodle2CC::Moodle2::Models::Quizzes::Question)).to be_truthy
      expect(question.type).to eq 'essay'
    end

    it 'parses description "questions" as standard questions' do
      xml = Nokogiri::XML(File.read(fixture_path(File.join('moodle2', 'backup', 'questions.xml'))))
      node = xml.at_xpath('/question_categories/question_category[@id = "2"]/questions/question[@id = "18"]')
      question = subject.parse_question(node)

      expect(question.is_a?(Moodle2CC::Moodle2::Models::Quizzes::Question)).to be_truthy
      expect(question.type).to eq 'description'
    end
  end
end