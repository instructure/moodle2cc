require 'spec_helper'

module Moodle2CC::Moodle2::Parsers::QuestionParsers
  describe QuestionParser do

    class FooBarParser < QuestionParser
    end


    it 'registers a question type for object creation' do
      node = Nokogiri::XML('<question><qtype>foobar</qtype></question>')
      parser = FooBarParser.new
      parser.stub(:parse_question)
      FooBarParser.stub(:new).and_return(parser)
      FooBarParser.register_parser_type 'foobar'
      QuestionParser.parse(node)
      expect(parser).to have_received(:parse_question)
    end

    it 'raises an exception for unknown parser types' do
      node = Nokogiri::XML('<question><qtype>non_existing_parser_type</qtype></question>')
      expect { FooBarParser.parse(node) }.to raise_exception
    end


  end
end