require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::BookParser do
  subject { Moodle2CC::Moodle2::Parsers::BookParser.new(fixture_path(File.join('moodle2', 'backup'))) }

  it "parses books" do
    books = subject.parse()
    #expect(books.name).to eq "My First Book"
    #expect(books.intro).to eq "&lt;p&gt;Description of my book&lt;/p&gt;"
    #expect(books.intro_format).to eq "1"
    #expect(books.numbering).to eq "0"
    #expect(books.custom_titles).to eq "0"
  end
end