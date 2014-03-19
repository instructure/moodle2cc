require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::BookConverter do
    let(:moodle2_book) {
      Moodle2::Models::Book.new.tap do |moodle2_book|
        moodle2_book.name = 'Book Name'
      end
    }

    before(:each) do
      subject.stub(:generate_unique_identifier) { 'some_unique_uuid' }
    end

    describe '#convert_to_pages' do
      it 'converts a moodle2 book into an array of canvas pages' do
        3.times { moodle2_book.chapters << Moodle2::Models::BookChapter.new }
        canvas_pages = subject.convert_to_pages(moodle2_book)

        expect(canvas_pages.size).to eq 3

        canvas_pages.each do |item|
          expect(item).to be_a CanvasCC::Models::Page
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
        expect(page.href).to eq 'wiki_content/some_unique_uuid-chapter-title.html'
        expect(page.files.size).to eq 1
        expect(page.files.first).to eq 'wiki_content/some_unique_uuid-chapter-title.html'
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
        expect(page.href).to eq 'wiki_content/some_unique_uuid-book-name.html'
        expect(page.files.size).to eq 1
        expect(page.files.first).to eq 'wiki_content/some_unique_uuid-book-name.html'
        expect(page.body).to eq 'intro html'
      end

    end

    describe '#convert' do
      it 'converts a moodle2 book into a canvas module' do
        canvas_module = subject.convert(moodle2_book)
        expect(canvas_module.identifier).to eq 'some_unique_uuid'
        expect(canvas_module.title).to eq 'Book Name'
        expect(canvas_module.workflow_state).to eq 'active'
      end

      it 'does not add the intro content if there is no intro' do
        canvas_module = subject.convert(moodle2_book)
        expect(canvas_module.module_items.size).to eq 0
      end

      it 'adds moodle2 chapters as module items to canvas modules' do
        3.times { moodle2_book.chapters << Moodle2::Models::BookChapter.new }
        canvas_module = subject.convert(moodle2_book)
        module_items = canvas_module.module_items

        expect(module_items.size).to eq 3
        module_items.each_with_index do |item, index|
          expect(item).to be_a CanvasCC::Models::ModuleItem
        end
      end

      it 'converts a moodle2 chapter to a module item' do
        chapter = Moodle2::Models::BookChapter.new
        chapter.title = 'Chapter Title'
        chapter.content = 'chapter content'
        chapter.hidden = false

        moodle2_book.chapters << chapter
        canvas_module = subject.convert(moodle2_book)
        module_item = canvas_module.module_items.first
        resource = module_item.resource

        expect(module_item.identifier).to eq 'some_unique_uuid'
        expect(module_item.content_type).to eq 'WikiPage'
        expect(module_item.workflow_state).to eq 'active'
        expect(module_item.title).to eq 'Chapter Title'
        expect(module_item.indent).to eq '1'
        expect(module_item.identifierref).to eq 'm2d41d8cd98f00b204e9800998ecf8427e_chapter'
      end

      it 'hides model items that come from hidden chapters' do
        chapter = Moodle2::Models::BookChapter.new
        chapter.hidden = true

        moodle2_book.chapters << chapter
        canvas_module = subject.convert(moodle2_book)
        module_item = canvas_module.module_items.first

        expect(module_item.workflow_state).to eq 'unpublished'
      end

      it 'sets indent to 2 for subchapters' do
        chapter = Moodle2::Models::BookChapter.new
        chapter.subchapter = true

        moodle2_book.chapters << chapter
        canvas_module = subject.convert(moodle2_book)
        module_item = canvas_module.module_items.first

        expect(module_item.indent).to eq '2'
      end
    end
  end
end