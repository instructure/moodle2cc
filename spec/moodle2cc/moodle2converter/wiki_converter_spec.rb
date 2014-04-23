require 'spec_helper'

module Moodle2CC::Moodle2Converter
  describe WikiConverter do
    let(:moodle_wiki){Moodle2CC::Moodle2::Models::Wiki.new}

    it 'converts a moodle wiki to canvas pages' do
      moodle_wiki.id = 'page_id'
      moodle_wiki.name = 'wiki name'
      moodle_wiki.intro = '<h2>wiki description</h2>'
      moodle_wiki.visible = true
      moodle_wiki.first_page_title = 'first page name'

      moodle_wiki.pages = [
        {:id => '27', :title => "first page name", :content => "<p>front page content</p>"},
        {:id => '28', :title => "other page", :content => "<p>other page content</p>"}
      ]

      canvas_pages = subject.convert(moodle_wiki)
      expect(canvas_pages.count).to eq 2
      first_page = canvas_pages.detect{|page| page.title == "wiki name"}
      other_page = canvas_pages.detect{|page| page.title == "other page"}

      expect(first_page.identifier).not_to eq other_page.identifier

      canvas_pages.each do |canvas_page|
        expect(canvas_page.workflow_state).to eq 'active'
        expect(canvas_page.editing_roles).to eq 'teachers'
      end

      expect(other_page.body).to eq '<p>other page content</p>'
      expect(first_page.body).to eq '<h2>wiki description</h2><p>front page content</p>'
    end

  end
end