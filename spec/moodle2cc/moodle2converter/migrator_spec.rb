require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::Migrator do
    subject(:migrator) { Moodle2Converter::Migrator.new('src_dir', 'out_dir') }
    let(:canvas_course) { CanvasCC::Models::Course.new }

    let(:moodle_course) { Moodle2CC::Moodle2::Models::Course.new }
    let(:canvas_page) { p = Moodle2CC::CanvasCC::Models::Page.new; p.title = "sometitle"; p }
    let(:canvas_discussion) {Moodle2CC::CanvasCC::Models::Discussion.new}
    let(:canvas_assignment) {Moodle2CC::CanvasCC::Models::Assignment.new}
    let(:canvas_assessment) {Moodle2CC::CanvasCC::Models::Assessment.new}

    before(:each) do
      extractor = double('extractor', extract: nil)

      allow(extractor).to receive(:extract).and_yield(moodle_course)

      allow(Moodle2::Extractor).to receive(:new).and_return(extractor)
      allow_any_instance_of(Moodle2Converter::CourseConverter).to receive(:convert).and_return(canvas_course)
      allow_any_instance_of(Moodle2Converter::SectionConverter).to receive(:convert)
      allow_any_instance_of(Moodle2Converter::FileConverter).to receive(:convert)
      allow_any_instance_of(Moodle2Converter::PageConverter).to receive(:convert)
      allow_any_instance_of(Moodle2Converter::WikiConverter).to receive(:convert)
      allow_any_instance_of(Moodle2Converter::DiscussionConverter).to receive(:convert)
      allow_any_instance_of(Moodle2Converter::AssignmentConverter).to receive(:convert)
      allow_any_instance_of(Moodle2Converter::FolderConverter).to receive(:convert)
      allow_any_instance_of(Moodle2Converter::BookConverter).to receive(:convert_to_pages)
      allow_any_instance_of(Moodle2CC::CanvasCC::Models::Assessment).to receive(:resolve_question_references!)
      allow(Moodle2Converter::HtmlConverter).to receive(:new) { double('html_converter', convert: true) }
      allow_any_instance_of(Moodle2Converter::GlossaryConverter).to receive(:convert)
      allow(CanvasCC::CartridgeCreator).to receive(:new).and_return(double(create: nil))
    end

    describe '#migrate' do
      it 'converts courses' do
        converter = double(convert: canvas_course)
        allow(Moodle2Converter::CourseConverter).to receive(:new).and_return(converter)
        migrator.migrate
        expect(converter).to have_received(:convert)
      end

      it 'converts files' do
        files = [
          double('file_1', content_hash: 'a'),
          double('file_1', content_hash: 'a'),
          double('file_1', content_hash: 'b')
        ]
        moodle_course.files = files
        allow_any_instance_of(Moodle2Converter::FileConverter).to receive(:convert).and_return('file')
        migrator.migrate
        expect(canvas_course.files).to eq ['file', 'file', 'file']
      end

      it 'converts pages' do
        moodle_course.pages = [:page1, :page2]
        allow_any_instance_of(Moodle2Converter::PageConverter).to receive(:convert).and_return(canvas_page)
        allow(migrator).to receive(:generate_unique_identifier).and_return('some_random_id')
        migrator.migrate
        expect(canvas_course.pages.compact).to eq [canvas_page, canvas_page]
        expect(canvas_course.pages.first.href).to eq 'wiki_content/some_random_id/sometitle.html'
      end

      it 'converts wikis' do
        moodle_course.wikis = [:wiki1, :wiki2]
        allow_any_instance_of(Moodle2Converter::WikiConverter).to receive(:convert).and_return([canvas_page, canvas_page])
        migrator.migrate
        expect(canvas_course.pages).to eq [canvas_page] * 4
      end

      it 'converts discussions' do
        moodle_course.forums = [:discussion1, :discussion2]
        allow_any_instance_of(Moodle2Converter::DiscussionConverter).to receive(:convert).and_return(canvas_discussion)
        migrator.migrate
        expect(canvas_course.discussions).to eq [canvas_discussion, canvas_discussion]
      end

      it 'converts assignments' do
        moodle_course.assignments = [:assign1, :assign2]
        allow_any_instance_of(Moodle2CC::Moodle2Converter::AssignmentConverter).to receive(:convert).and_return(canvas_assignment)
        migrator.migrate
        expect(canvas_course.assignments).to eq [canvas_assignment, canvas_assignment]
      end

      it 'converts folders' do
        moodle_course.folders = [:folder1, :folder2]
        allow_any_instance_of(Moodle2CC::Moodle2Converter::FolderConverter).to receive(:convert).and_return(canvas_page)
        migrator.migrate
        expect(canvas_course.pages.compact).to eq [canvas_page, canvas_page]
      end

      it 'converts books' do
        moodle_course.books = [:book1, :book2]
        allow_any_instance_of(Moodle2CC::Moodle2Converter::BookConverter).to receive(:convert_to_pages).and_return([canvas_page])
        migrator.migrate

        expect(canvas_course.pages.compact).to eq [canvas_page, canvas_page]
      end

      it 'converts glossaries' do
        moodle_course.glossaries = [:glossary1, :glossary1]
        allow_any_instance_of(Moodle2CC::Moodle2Converter::GlossaryConverter).to receive(:convert).and_return(canvas_page)
        migrator.migrate

        expect(canvas_course.pages.compact).to eq [canvas_page, canvas_page]
      end

      context 'sections' do
        it 'converts sections with summaries to pages' do
          allow_any_instance_of(Moodle2CC::Moodle2Converter::SectionConverter).to receive(:convert_to_summary_page).and_return(canvas_page)
          section1 = Moodle2CC::Moodle2::Models::Section.new
          section1.summary = 'summary'
          section2 = Moodle2CC::Moodle2::Models::Section.new
          section2.summary = '  '
          moodle_course.sections = [section1, section2]
          migrator.migrate

          expect(canvas_course.pages.compact).to eq [canvas_page]
        end

        it 'converts sections to modules' do
          section1 = Moodle2CC::Moodle2::Models::Section.new
          section1.summary = 'summary'
          section2 = Moodle2CC::Moodle2::Models::Section.new
          section2.summary = '  '
          allow_any_instance_of(Moodle2CC::Moodle2Converter::SectionConverter).to receive(:convert).and_return(:canvas_module)
          moodle_course.sections = [section1, section2]
          migrator.migrate

          expect(canvas_course.canvas_modules.compact).to eq [:canvas_module]
        end
      end

      context '#resolve_duplicate_page_titles!' do
        it "should order renumbering of page titles according to position in index" do
          page1 = Moodle2CC::CanvasCC::Models::Page.new
          page2 = Moodle2CC::CanvasCC::Models::Page.new
          page3 = Moodle2CC::CanvasCC::Models::Page.new

          canvas_course.pages = [page1, page2, page3]
          canvas_course.pages.each_with_index do |page, idx|
            page.identifier = idx.to_s
            page.title = 'page title'
          end

          module1 = Moodle2CC::CanvasCC::Models::CanvasModule.new
          module_item1 = Moodle2CC::CanvasCC::Models::ModuleItem.new
          module_item1.identifierref = page3.identifier
          module1.module_items = [module_item1]

          module2 = Moodle2CC::CanvasCC::Models::CanvasModule.new
          module_item2 = Moodle2CC::CanvasCC::Models::ModuleItem.new
          module_item2.identifierref = page2.identifier
          module2.module_items = [module_item2]

          canvas_course.canvas_modules = [module1, module2]

          migrator.migrate

          expect(page3.title).to eq 'page title'
          expect(page2.title).to eq 'page title-2'
          expect(page1.title).to eq 'page title-3'
        end
      end

      context "html conversion" do
        let(:converter){double('invitation', :convert => 'converted_html')}

        before(:each) do
          allow(Moodle2CC::Moodle2Converter::HtmlConverter).to receive(:new).and_return(converter)
        end

        it 'converts pages' do
          canvas_course.pages = [Moodle2CC::CanvasCC::Models::Page.new, Moodle2CC::CanvasCC::Models::Page.new]
          migrator.migrate
          expect(converter).to have_received(:convert).exactly(2)
          canvas_course.pages.each{|page| expect(page.body).to eq 'converted_html'}
        end

        it 'converts discussions' do
          canvas_course.discussions = [Moodle2CC::CanvasCC::Models::Discussion.new, Moodle2CC::CanvasCC::Models::Discussion.new]
          migrator.migrate
          expect(converter).to have_received(:convert).exactly(2)
          canvas_course.discussions.each{|discussion| expect(discussion.text).to eq 'converted_html'}
        end

        it 'converts assignments' do
          moodle_course.show_grades = false
          canvas_course.assignments = [Moodle2CC::CanvasCC::Models::Assignment.new, Moodle2CC::CanvasCC::Models::Assignment.new]
          migrator.migrate
          expect(converter).to have_received(:convert).exactly(2)
          canvas_course.assignments.each{|assignment| expect(assignment.body).to eq 'converted_html'}
          canvas_course.assignments.each{|assignment| expect(assignment.muted).to eq true}
        end

        it 'converts assessment' do
          canvas_course.assessments = [Moodle2CC::CanvasCC::Models::Assessment.new, Moodle2CC::CanvasCC::Models::Assessment.new]
          migrator.migrate
          expect(converter).to have_received(:convert).exactly(2)
          canvas_course.assessments.each do |assessment|
            expect(assessment).to have_received(:resolve_question_references!).exactly(1)
            expect(assessment.description).to eq 'converted_html'
          end
        end

        it 'converts assessment questions' do
          assmt = Moodle2CC::CanvasCC::Models::Assessment.new
          q1 = Moodle2CC::CanvasCC::Models::Question.new
          a1 = Moodle2CC::CanvasCC::Models::Answer.new
          q1.answers = [a1]

          q_group = Moodle2CC::CanvasCC::Models::QuestionGroup.new
          q2 = Moodle2CC::CanvasCC::Models::Question.new
          a2 = Moodle2CC::CanvasCC::Models::Answer.new
          q2.answers = [a2]
          q_group.questions = [q2]

          assmt.items = [q1, q_group]
          canvas_course.assessments = [assmt]
          migrator.migrate

          expect(q1.material).to eq 'converted_html'
          expect(q2.material).to eq 'converted_html'
          expect(a1.answer_text).to eq 'converted_html'
          expect(a2.answer_text).to eq 'converted_html'
        end

        it 'converts question bank questions' do
          qb = Moodle2CC::CanvasCC::Models::QuestionBank.new
          q1 = Moodle2CC::CanvasCC::Models::CalculatedQuestion.new
          allow(q1).to receive(:post_process!)
          a1 = Moodle2CC::CanvasCC::Models::Answer.new
          q1.general_feedback = 'a'
          a1.feedback = 'a'

          q1.answers = [a1]
          qb.questions = [q1]

          canvas_course.question_banks = [qb]
          migrator.migrate

          expect(q1).to have_received(:post_process!)
          expect(q1.material).to eq 'converted_html'
          expect(q1.general_feedback).to eq 'converted_html'
          expect(a1.answer_text).to eq 'converted_html'
          expect(a1.feedback).to eq 'converted_html'
        end
      end
    end

    it 'sets the imscc_path' do
      allow(CanvasCC::CartridgeCreator).to receive(:new).and_return(double(create: 'out_dir'))
      migrator.migrate
      expect(migrator.imscc_path).to eq('out_dir')
    end

  end
end