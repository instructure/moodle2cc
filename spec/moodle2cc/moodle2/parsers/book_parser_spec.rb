require 'spec_helper'

describe Moodle2CC::Moodle2::Parsers::BookParser do
  subject { Moodle2CC::Moodle2::Parsers::BookParser.new(fixture_path(File.join('moodle2', 'backup'))) }

  it "parses books" do
    book = subject.parse().first
    chapter = book.chapters.first

    expect(book.name).to eq "My First Book"
    expect(book.intro).to eq "<p>Description of my book</p>"
    expect(book.intro_format).to eq "1"
    expect(book.numbering).to eq "0"
    expect(book.custom_titles).to eq "0"
    expect(book.chapters.size).to eq 3

    expect(chapter.id).to eq "1"
    expect(chapter.pagenum).to eq "1"
    expect(chapter.subchapter).to be_false
    expect(chapter.title).to eq "Chapter 1"
    expect(chapter.content).to eq "<p>Chapter 1 content</p>"
    expect(chapter.content_format).to eq "1"
    expect(chapter.hidden).to be_false
  end

  it "sets subchapter to true for subchapters" do
    book = subject.parse.first
    chapter = book.chapters[1]
    expect(chapter.subchapter).to be_true
  end
end