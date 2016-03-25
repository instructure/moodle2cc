require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::BookConverter do
    let(:moodle2_book) {
      Moodle2::Models::Book.new.tap do |moodle2_book|
        moodle2_book.name = 'Book Name'
        moodle2_book.visible = false
      end
    }

    before(:each) do
      allow(subject).to receive(:generate_unique_identifier) { 'some_unique_uuid' }
    end

    describe '#convert_to_pages' do
      it 'converts a moodle2 book into an array of canvas pages' do
        3.times { moodle2_book.chapters << Moodle2::Models::BookChapter.new }
        canvas_pages = subject.convert_to_pages(moodle2_book)

        expect(canvas_pages.size).to eq 3

        canvas_pages.each do |item|
          expect(item).to be_a CanvasCC::Models::Page
          expect(item.workflow_state).to eq 'unpublished'
        end
      end

      it 'converts moodle chapters into canvas pages' do
        chapter = Moodle2::Models::BookChapter.new
        chapter.title = 'Chapter Title'
        chapter.content = 'chapter content'
        chapter.hidden = false

        moodle2_book.chapters << chapter
        canvas_pages = subject.convert_to_pages(moodle2_book)

        page = canvas_pages.first
        expect(page).to be_a CanvasCC::Models::Page
        expect(page.identifier).to eq 'm2d41d8cd98f00b204e9800998ecf8427e_chapter'
        expect(page.type).to eq 'webcontent'
        expect(page.title).to eq 'Chapter Title'
        expect(page.href).to eq 'wiki_content/books/some_unique_uuid/chapter-title.html'
        expect(page.body).to eq 'chapter content'
      end

      it 'creates a page for intro content' do
        moodle2_book.intro = 'intro html'

        canvas_pages = subject.convert_to_pages(moodle2_book)

        expect(canvas_pages.size).to eq 1
        page = canvas_pages.first
        expect(page).to be_a CanvasCC::Models::Page
        expect(page.identifier).to eq 'm2d41d8cd98f00b204e9800998ecf8427e_book_intro'
        expect(page.type).to eq 'webcontent'
        expect(page.title).to eq 'Book Name'
        expect(page.href).to eq 'wiki_content/books/some_unique_uuid/book-name.html'
        expect(page.body).to eq 'intro html'
      end

    end

    describe '#convert_to_module_items' do
      it 'creates a label module item' do
        module_items = subject.convert_to_module_items(moodle2_book)
        label = module_items.first

        expect(label.content_type).to eq 'ContextModuleSubHeader'
        expect(label.workflow_state).to eq 'unpublished'
        expect(label.title).to eq 'Book Name'
        expect(label.indent).to eq '0'
        expect(label.identifier).to eq 'some_unique_uuid'
      end

      it 'creates a module item for intro content' do
        moodle2_book.intro = 'intro html'
        module_items = subject.convert_to_module_items(moodle2_book)
        intro = module_items.last

        expect(intro.content_type).to eq 'WikiPage'
        expect(intro.workflow_state).to eq 'unpublished'
        expect(intro.title).to eq 'Introduction'
        expect(intro.identifier).to eq 'some_unique_uuid'
        expect(intro.identifierref).to eq 'm2d41d8cd98f00b204e9800998ecf8427e_book_intro'
        expect(intro.indent).to eq '1'
      end

      it 'creates a module item for chapters' do
        moodle2_book.intro = 'intro html'
        moodle_chapter = Moodle2::Models::BookChapter.new
        moodle_chapter.title = 'Chapter Title'
        moodle_chapter.hidden = false

        moodle2_book.chapters << moodle_chapter
        module_items = subject.convert_to_module_items(moodle2_book)
        canvas_chapter = module_items.last

        expect(canvas_chapter.content_type).to eq 'WikiPage'
        expect(canvas_chapter.workflow_state).to eq 'active'
        expect(canvas_chapter.title).to eq 'Chapter Title'
        expect(canvas_chapter.identifier).to eq 'some_unique_uuid'
        expect(canvas_chapter.identifierref).to eq 'm2d41d8cd98f00b204e9800998ecf8427e_chapter'
        expect(canvas_chapter.indent).to eq '1'
      end

      it 'indents subchapters' do
        moodle2_book.intro = 'intro html'
        moodle_chapter = Moodle2::Models::BookChapter.new
        moodle_chapter.subchapter = true

        moodle2_book.chapters << moodle_chapter
        module_items = subject.convert_to_module_items(moodle2_book)
        canvas_chapter = module_items.last

        expect(canvas_chapter.indent).to eq '2'
      end

      it 'hides hiddden chapters' do
        moodle2_book.intro = 'intro html'
        moodle_chapter = Moodle2::Models::BookChapter.new
        moodle_chapter.hidden = true

        moodle2_book.chapters << moodle_chapter
        module_items = subject.convert_to_module_items(moodle2_book)
        canvas_chapter = module_items.last

        expect(canvas_chapter.workflow_state).to eq 'unpublished'
      end
    end
  end
end