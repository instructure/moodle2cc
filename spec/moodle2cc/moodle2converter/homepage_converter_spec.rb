require 'spec_helper'

module Moodle2CC
  describe Moodle2Converter::HomepageConverter do
    let(:section) { Moodle2::Models::Section.new }
    it 'converts a section to a page' do
      subject.stub(:generate_unique_identifier).and_return('some_random_id')
      section.name = 'Name'
      section.summary = 'Summary Content'

      page = subject.convert(section)

      expect(page).to be_a CanvasCC::Models::Page
      expect(page.identifier).to eq 'some_random_id'
      expect(page.title).to eq 'Name'
      expect(page.workflow_state).to eq 'active'
      expect(page.editing_roles).to eq 'teachers'
      expect(page.body).to eq 'Summary Content'
      expect(page.href).to eq 'wiki_content/front-page.html'
    end

    it 'defaults the page name to "Front Page"' do
      page = subject.convert(section)

      expect(page.title).to eq 'Front Page'
    end

    #context 'links to content' do
    #  it '' do
    #    page = Moodle2::Models::Page.new
    #    page.id =
    #    section.activites <<
    #  end
    #
    #end
  end
end

