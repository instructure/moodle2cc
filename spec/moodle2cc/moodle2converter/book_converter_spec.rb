require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::BookConverter do
    let(:moodle2_book) {
      Moodle2::Models::Book.new.tap do |moodle2_book|
        moodle2_book.name = 'Book Name'
        moodle2_book.intro = 'intro'
      end
    }

    let(:moodle2_chapter) {
      Moodle2::Models::BookChapter.new.tap do |book_chapter|
        book_chapter.title = 'Chapter Title'
        book_chapter.content = 'chapter content'
        book_chapter.hidden = false
      end
    }

    let(:moodle2_hidden_chapter) {
      Moodle2::Models::BookChapter.new.tap do |book_chapter|
        book_chapter.title = 'hidden chapter title'
        book_chapter.content = 'hidden chapter content'
        book_chapter.hidden = true
      end
    }

    let(:moodle2_subchapter) {
      Moodle2::Models::BookChapter.new.tap do |book_chapter|
        book_chapter.title = 'sub chapter title'
        book_chapter.content = 'sub chapter content'
        book_chapter.hidden = true
      end
    }

    describe '#convert' do
      before(:each) do
        SecureRandom.stub(:uuid) { 'some_unique_uuid' }
      end

      it 'converts a moodle2 book into a canvas module' do
        canvas_module = subject.convert(moodle2_book)
        expect(canvas_module.identifier).to eq 'module_d22dda77ebaaa68dcc0f1cab8516bb2b'
        expect(canvas_module.title).to eq 'Book Name'
        expect(canvas_module.workflow_state).to eq 'active'
      end

      it 'adds a module item with intro content' do
        canvas_module = subject.convert(moodle2_book)
        module_item = canvas_module.module_items.first
        resource = module_item.resource

        expect(module_item.identifier).to eq 'some_unique_uuid'
        expect(module_item.content_type).to eq 'WikiPage'
        expect(module_item.workflow_state).to eq 'active'
        expect(module_item.title).to eq 'Book Name'
        expect(module_item.indent).to eq '0'

        expect(resource.identifier).to eq 'CC_d22dda77ebaaa68dcc0f1cab8516bb2b'
        expect(resource.type).to eq 'webcontent'
        expect(resource.href).to eq 'wiki_content/some_unique_uuid-book-name.html'
        expect(resource.files.size).to eq 1
        expect(resource.files.first).to eq 'wiki_content/some_unique_uuid-book-name.html'
      end

      it 'adds moodle2 chapters as module items to canvas modules' do
        moodle2_book.chapters << moodle2_chapter
        moodle2_book.chapters << moodle2_hidden_chapter
        moodle2_book.chapters << moodle2_subchapter
        canvas_module = subject.convert(moodle2_book)
        module_items = canvas_module.module_items

        expect(module_items.size).to eq 4
        module_items.each_with_index do |item, index|
          expect(item).to be_a CanvasCC::Model::ModuleItem
        end
      end

      it 'converts a moodle2 chapter to a module item' do
        moodle2_book.chapters << moodle2_chapter
        canvas_module = subject.convert(moodle2_book)
        module_item = canvas_module.module_items.last
        resource = module_item.resource

        expect(module_item.identifier).to eq 'some_unique_uuid'
        expect(module_item.content_type).to eq 'WikiPage'
        expect(module_item.workflow_state).to eq 'active'
        expect(module_item.title).to eq 'Chapter Title'
        expect(module_item.indent).to eq '1'

        expect(resource.identifier).to eq 'CC_d22dda77ebaaa68dcc0f1cab8516bb2b'
        expect(resource.type).to eq 'webcontent'
        expect(resource.href).to eq 'wiki_content/some_unique_uuid-chapter-title.html'
        expect(resource.files.size).to eq 1
        expect(resource.files.first).to eq 'wiki_content/some_unique_uuid-chapter-title.html'
      end
    end
  end
end